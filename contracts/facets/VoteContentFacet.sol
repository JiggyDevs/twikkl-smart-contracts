// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Modifiers, AppStorage, VotersDetails, Content} from "../libraries/AppStorage.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IERC721.sol";

/**
 * @title VoteContentFacet
 * @dev A smart contract for content voting using NFT and ERC20 token requirements.
 */

contract VoteContentFacet is Modifiers {
    AppStorage internal s;

    VotersDetails internal v;

    event ContentFlagged(uint256 contentId);

    event ValidatorsReviewedContent(uint256 contentId, bool vote);

    event MemberVoted(address indexed voter, uint256 contentId, bool vote);

    event ContentRedFlagged(uint256 contentId);

    event VotingStarted(uint256 deadline);

    event VotingExtended(uint256 newDeadline);

    /**
     * @dev Get the total number of voters.
     */
    function totalVoters() public view returns (uint256) {
        return s._totalVoters;
    }

    /**
     * @dev Check if voting is currently active.
     */
    function isVotingOn() public view returns (bool) {
        return s._isVotingOn;
    }

       /**
     * @dev Start the voting process. Only the owner can call this function.
     * @return True if voting is started.
     */
    function startVoting(uint256 duration) public onlyOwner returns (bool) {

        s.votingDeadline = block.timestamp + duration;

        emit VotingStarted(s.votingDeadline);

       return s._isVotingOn = true;
    }

    /**
     * @dev Extend the voting deadline. Only the owner can call this function.
     * @param extraTime The extra time to add to the voting duration in seconds.
     */
    function extendVoting(uint256 extraTime) public onlyOwner {

        s.votingDeadline += extraTime;

        emit VotingExtended(s. votingDeadline);
    }


    /**
     * @dev Stop the voting process. Only the owner can call this function.
     * @return True if voting is stopped.
     */
    function stopVoting() public onlyOwner returns (bool) {
       s.votingDeadline = block.timestamp; 

       return s._isVotingOn = false;
    }

    /**
     * @dev Get the NFT contract address.
     */
    function checkMembershipNFTAdress() public view returns (address) {
        return s._membershipNftAddress;
    }

    /**
     * @dev Get the NFT contract address.
     */
    function checkValidatorsNFTAdress() public view returns (address) {
        return s._validatorNftAddress;
    }

    /**
     * @dev Get the ERC20 token contract address.
     */
    function checkJiggyTokenAdress() public view returns (address) {
        return s._jiggyTokenAddress;
    }

    /**
     * @dev Set the NFT contract address. Only the owner can call this function.
     * @param NFTaddress The address of the NFT contract.
     */
    function setMembershipNFTAdress(address NFTaddress) public onlyOwner {
        s._membershipNftAddress = NFTaddress;
    }

    /**
     * @dev Set the NFT contract address. Only the owner can call this function.
     * @param NFTaddress The address of the NFT contract.
     */
    function setValidatorsNFTAdress(address NFTaddress) public onlyOwner {
        s._validatorNftAddress = NFTaddress;
    }

    /**
     * @dev Set the jiggy token contract address. Only the owner can call this function.
     * @param tokenAddress The address of the ERC20 token contract.
     */
    function setJiggyTokenAdress(address tokenAddress) public onlyOwner {
        s._jiggyTokenAddress = tokenAddress;
    }                                                                                     
    /**
     * @dev Get the total number of red flagged content.
     */
    function totalRedFlaggedContent() public view returns (uint256) {
        return s._totalRedFlaggedContent;
    }
  
    /**
     * @dev Get content details by content ID.
     * @param contentID The ID of the content.
     * @return Content details.
     */
    function getContent(uint256 contentID) public view returns (Content memory) {
        return s.ContentBank[contentID];
    }
   
    /**
     * @dev Cast a vote for a content for general member NFT holders.
     * @param voteValue The vote value (true for yes, false for no).
     * @param contentID The ID of the content.
     */    
    function voteWithMembershipNFT(bool voteValue, uint256 contentID) public {
 
        Content storage updateContent = s.ContentBank[contentID];


        // checks if voting time is on, if not, don't allow to vote
        require(block.timestamp <= s.votingDeadline, "Voting has ended");        

        // require that voters have NFT in their wallet
        require(hasMembershipNFT(msg.sender), "You must have the membership NFT to vote");

        // Ensure the content has be reviewed by validators 
        require(updateContent.       validatorsApprovedForRedFlagging, "Not approved for red flagging by validators");

        // Ensure the voter hasn't voted on this content already
        require(!s.generalVotes[msg.sender][contentID], "You have already voted on this content");

        // Updating the voters's voting record
        s.generalVotes[msg.sender][contentID] = true;

        // increment votes count for either yes or no votes
        if (voteValue) {
            updateContent.generalYesVotes++;
        } else {
            updateContent.generalNoVotes++;
        }

        updateContent.totalGeneralVotesCount++;

        s._totalVoters++;

        emit MemberVoted(msg.sender, contentID, voteValue);

    }

    /**
     * @dev Cast a vote for a content for validators NFT holders.
     * @param voteValue The vote value (true for yes, false for no).
     * @param contentID The ID of the content.
     */    
    function voteWithValidatorNFT(bool voteValue, uint256 contentID) public {

        Content storage updateContent = s.ContentBank[contentID];

        // checks if voting time is on, if not, don't allow to vote
        require(block.timestamp <= s.votingDeadline, "Voting has ended");

        // checks if voting time is on, if not, don't allow to vote
        require(!s._isVotingOn, "Wait for voting time please!");

        // require that voters have NFT in their wallet
        require(hasValidatorNFT(msg.sender), "You must have the validators NFT to vote");


        // Ensure the validator hasn't voted on this content already
        require(!s.validatorsVotes[msg.sender][contentID], "You have already reviewed this content");

        // Updating the validators's voting record
        s.validatorsVotes[msg.sender][contentID] = true;
        
        // increment votes count for either yes or no votes
        if (voteValue) {
            updateContent.validatorsYesVotes++;
        } else {
            updateContent.validatorsNoVotes++;
        }

        updateContent.totalValidatorsVotesCount++;

        s._totalVoters++;

        emit ValidatorsReviewedContent(contentID, voteValue);

    }

    /**
     * @dev Cast a vote for a content for general member NFT holders.
     * @param voteValue The vote value (true for yes, false for no).
     * @param contentID The ID of the content.
     */    
    function voteWithTokenForMembers(bool voteValue, uint256 contentID) public {
 
        Content storage updateContent = s.ContentBank[contentID];

        // checks if voting time is on, if not, don't allow to vote
        require(block.timestamp <= s.votingDeadline, "Voting has ended");        

        // require that voters have NFT in their wallet
        require(hasJiggyToken(msg.sender), "You must have at least one jiggy token in your wallet to vote");

        // Ensure the content has be reviewed by validators 
        require(updateContent.validatorsApprovedForRedFlagging, "Not approved for red flagging by validators");

        // Ensure the voter hasn't voted on this content already
        require(!s.generalVotes[msg.sender][contentID], "You have already voted on this content");

        // Updating the voters's voting record
        s.generalVotes[msg.sender][contentID] = true;

        // increment votes count for either yes or no votes
        if (voteValue) {
            updateContent.generalYesVotes++;
        } else {
            updateContent.generalNoVotes++;
        }

        updateContent.totalGeneralVotesCount++;

        s._totalVoters++;

        emit MemberVoted(msg.sender, contentID, voteValue);

    }

    /**
     * @notice Flag a content by its ID.
     * @param contentID The ID of the content to be flagged.
     */
    function FlagContent(uint256 contentID, string memory _reasonForFlagging) public {

        require(contentID != 0, "Flag valid content!");

        require(msg.sender != address(0), "No permission to flag content");

        Content storage updateContent = s.ContentBank[contentID]; 

        // Updates the flaggedContent details 
        updateContent.flagged = true; 
        updateContent.flaggedBy = msg.sender;
        updateContent.flaggedTimestamp = block.timestamp;
        updateContent.reasonForFlagging = _reasonForFlagging;

        s._totalFlaggedContent++;
    }

     /**
     * @dev Conclude content voting status after validators or general voting. Only the owner can call this function.
     */
    function finalizeContentVoting(uint256 contentID) public onlyOwner {

        require(block.timestamp > s.votingDeadline, "Voting is still ongoing"); 
        
        Content storage updateContent = s.ContentBank[contentID];

        require(updateContent.validatorsApprovedForRedFlagging, "Not approved by validators for flagging");

        // Check final result for validators Voting
        if (updateContent.validatorsYesVotes > updateContent.validatorsNoVotes) {

            updateContent.validatorsApprovedForRedFlagging = true;

        }

        // Check final result for members voting
        if (updateContent.generalYesVotes > updateContent.generalNoVotes) {

            updateContent.isRedFlagged = true;

            s._totalRedFlaggedContent++;

            emit ContentRedFlagged(contentID);
        }

    }


    /**
     * @dev Check if a voter has the required  jiggy token.
     * @param voter The address of the voter.
     * @return True if the voter has the required jiggy token.
     */
    function hasJiggyToken(address voter) internal view returns (bool) {

        // Check if the voter has jiggy token balance
        uint256 jiggyTokenBalance = IERC20(s._jiggyTokenAddress).balanceOf(voter); 

        return (jiggyTokenBalance > 0);

    }


     /**
     * @dev Check if a voter has the required vaidators NFT.
     * @param voter The address of the voter.
     * @return True if the voter has the required NFT
     * and ERC20 token.
     */
    function hasValidatorNFT(address voter) internal view returns (bool) {

        // Check if the voter owns the NFT
        bool _validatorNFT = IERC721(s._validatorNftAddress).balanceOf(voter) > 0; 

        return _validatorNFT;

    }


    /**
     * @dev Check if a voter has the required membership  NFT.
     * @param voter The address of the voter.
     * @return True if the voter has the required NFT
     * and ERC20 token.
     */
    function hasMembershipNFT(address voter) internal view returns (bool) {

        // Check if the voter owns the NFT
        bool _membershipNFT = IERC721(s._membershipNftAddress).balanceOf(voter) > 0; 

        return _membershipNFT;

    }
 


}