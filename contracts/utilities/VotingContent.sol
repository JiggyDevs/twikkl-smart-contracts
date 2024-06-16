// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title VoteContent
 * @dev A smart contract for content voting using NFT and ERC20 token requirements.
 */
contract VoteContent {
    address public owner;

    struct Content {
        uint256 contentID;
        string contentName;
        address contentCreator;
        string contentDescription;
        bool flagged;
        uint256 flaggedTimestamp;
        address flaggedBy;
        string reasonForFlagging;
        uint256 validatorsYesVotes;
        uint256 validatorsNoVotes;
        uint256 generalYesVotes;
        uint256 generalNoVotes;
        bool validatorsApprovedForRedFlagging;
        bool isRedFlagged;
        uint256 totalGeneralVotesCount;
        uint256 totalValidatorsVotesCount;
    }

    struct VotersDetails {
        address voterAddress;
        bool verified;
        mapping(uint256 => bool) hasVotedOnContent;
    }

    struct AppStorage {
        address _jiggyTokenAddress;
        address _membershipNftAddress;
        address _validatorNftAddress;
        uint256 _totalFlaggedContent;
        uint256 _totalRedFlaggedContent;
        uint256 _totalVoters;
        uint256 votingDeadline;
        bool _isVotingOn;
        mapping(uint256 => Content) ContentBank;
        mapping(address => VotersDetails) Voters;
        mapping(uint256 => Content) redFlaggedContents;
        mapping(address => mapping(uint256 => bool)) validatorsVotes;
        mapping(address => mapping(uint256 => bool)) generalVotes;
    }

    AppStorage internal s;

    event ContentFlagged(uint256 contentId);
    event ValidatorsReviewedContent(uint256 contentId, bool vote);
    event MemberVoted(address indexed voter, uint256 contentId, bool vote);
    event ContentRedFlagged(uint256 contentId);
    event VotingStarted(uint256 deadline);
    event VotingExtended(uint256 newDeadline);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can call this function");
        _;
    }

    constructor(
        address _jiggyTokenAddress,
        address _membershipNftAddress,
        address _validatorNftAddress
    ) {
        owner = msg.sender;
        s._jiggyTokenAddress = _jiggyTokenAddress;
        s._membershipNftAddress = _membershipNftAddress;
        s._validatorNftAddress = _validatorNftAddress;
    }

    function totalVoters() public view returns (uint256) {
        return s._totalVoters;
    }

    function isVotingOn() public view returns (bool) {
        return s._isVotingOn;
    }

    function startVoting(uint256 duration) public onlyOwner returns (bool) {
        s.votingDeadline = block.timestamp + duration;
        s._isVotingOn = true;
        emit VotingStarted(s.votingDeadline);
        return true;
    }

    function extendVoting(uint256 extraTime) public onlyOwner {
        s.votingDeadline += extraTime;
        emit VotingExtended(s.votingDeadline);
    }

    function stopVoting() public onlyOwner returns (bool) {
        s.votingDeadline = block.timestamp;
        s._isVotingOn = false;
        return true;
    }

    function checkMembershipNFTAddress() public view returns (address) {
        return s._membershipNftAddress;
    }

    function checkValidatorsNFTAddress() public view returns (address) {
        return s._validatorNftAddress;
    }

    function checkJiggyTokenAddress() public view returns (address) {
        return s._jiggyTokenAddress;
    }

    function setMembershipNFTAddress(address NFTaddress) public onlyOwner {
        s._membershipNftAddress = NFTaddress;
    }

    function setValidatorsNFTAddress(address NFTaddress) public onlyOwner {
        s._validatorNftAddress = NFTaddress;
    }

    function setJiggyTokenAddress(address tokenAddress) public onlyOwner {
        s._jiggyTokenAddress = tokenAddress;
    }

    function totalRedFlaggedContent() public view returns (uint256) {
        return s._totalRedFlaggedContent;
    }

    function getContent(uint256 contentID) public view returns (Content memory) {
        return s.ContentBank[contentID];
    }

    function voteWithMembershipNFT(bool voteValue, uint256 contentID) public {
        Content storage updateContent = s.ContentBank[contentID];

        require(block.timestamp <= s.votingDeadline, "Voting has ended");
        require(hasMembershipNFT(msg.sender), "You must have the membership NFT to vote");
        require(updateContent.validatorsApprovedForRedFlagging, "Not approved for red flagging by validators");
        require(!s.generalVotes[msg.sender][contentID], "You have already voted on this content");

        s.generalVotes[msg.sender][contentID] = true;

        if (voteValue) {
            updateContent.generalYesVotes++;
        } else {
            updateContent.generalNoVotes++;
        }

        updateContent.totalGeneralVotesCount++;
        s._totalVoters++;
        emit MemberVoted(msg.sender, contentID, voteValue);
    }

    function voteWithValidatorNFT(bool voteValue, uint256 contentID) public {
        Content storage updateContent = s.ContentBank[contentID];

        require(block.timestamp <= s.votingDeadline, "Voting has ended");
        require(s._isVotingOn, "Voting is not active");
        require(hasValidatorNFT(msg.sender), "You must have the validators NFT to vote");
        require(!s.validatorsVotes[msg.sender][contentID], "You have already reviewed this content");

        s.validatorsVotes[msg.sender][contentID] = true;

        if (voteValue) {
            updateContent.validatorsYesVotes++;
        } else {
            updateContent.validatorsNoVotes++;
        }

        updateContent.totalValidatorsVotesCount++;
        s._totalVoters++;
        emit ValidatorsReviewedContent(contentID, voteValue);
    }

    function voteWithTokenForMembers(bool voteValue, uint256 contentID) public {
        Content storage updateContent = s.ContentBank[contentID];

        require(block.timestamp <= s.votingDeadline, "Voting has ended");
        require(hasJiggyToken(msg.sender), "You must have at least one jiggy token in your wallet to vote");
        require(updateContent.validatorsApprovedForRedFlagging, "Not approved for red flagging by validators");
        require(!s.generalVotes[msg.sender][contentID], "You have already voted on this content");

        s.generalVotes[msg.sender][contentID] = true;

        if (voteValue) {
            updateContent.generalYesVotes++;
        } else {
            updateContent.generalNoVotes++;
        }

        updateContent.totalGeneralVotesCount++;
        s._totalVoters++;
        emit MemberVoted(msg.sender, contentID, voteValue);
    }

    function flagContent(uint256 contentID, string memory _reasonForFlagging) public {
        require(contentID != 0, "Flag valid content!");
        require(msg.sender != address(0), "No permission to flag content");

        Content storage updateContent = s.ContentBank[contentID];
        updateContent.flagged = true;
        updateContent.flaggedBy = msg.sender;
        updateContent.flaggedTimestamp = block.timestamp;
        updateContent.reasonForFlagging = _reasonForFlagging;

        s._totalFlaggedContent++;
        emit ContentFlagged(contentID);
    }

    function finalizeContentVoting(uint256 contentID) public onlyOwner {
        require(block.timestamp > s.votingDeadline, "Voting is still ongoing");

        Content storage updateContent = s.ContentBank[contentID];

        require(updateContent.validatorsApprovedForRedFlagging, "Not approved by validators for flagging");

        if (updateContent.validatorsYesVotes > updateContent.validatorsNoVotes) {
            updateContent.validatorsApprovedForRedFlagging = true;
        }

        if (updateContent.generalYesVotes > updateContent.generalNoVotes) {
            updateContent.isRedFlagged = true;
            s._totalRedFlaggedContent++;
            emit ContentRedFlagged(contentID);
        }
    }

    function hasJiggyToken(address voter) internal view returns (bool) {
        uint256 jiggyTokenBalance = IERC20(s._jiggyTokenAddress).balanceOf(voter);
        return (jiggyTokenBalance > 0);
    }

    function hasValidatorNFT(address voter) internal view returns (bool) {
        return IERC721(s._validatorNftAddress).balanceOf(voter) > 0;
    }

    function hasMembershipNFT(address voter) internal view returns (bool) {
        return IERC721(s._membershipNftAddress).balanceOf(voter) > 0;
    }
}