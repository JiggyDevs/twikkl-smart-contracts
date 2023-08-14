// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {AppStorage, VotersDetails, Content} from "../libraries/AppStorage.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/IERC721.sol";

//import the hardhat console
import "hardhat/console.sol";


contract VoteContentFacet  {
    AppStorage internal s;

    VotersDetails internal v;

    event VoteCast(address indexed voter, bool vote);

    function totalVoters() public view returns (uint256) {
        return s._totalVoters;
    }

    function isVotingOn() public view returns (bool) {
        return s._isVotingOn;
    }

    function checkNFTAdress() public view returns (address) {
        return s._nftAddress;
    }

    function checkTokenAdress() public view returns (address) {
        return s._tokenAddress;
    }

    function setNFTAdress(address NFTaddress) public {
        s._nftAddress = NFTaddress;
    }

    function setTokenAdress(address tokenAddress) public {
        s._tokenAddress = tokenAddress;
    }

    function totalFlaggedContent() public view returns (uint256) {
        return s._totalFlaggedContent;
    }

    function addVoters(address voterAddress) public {
        require(voterAddress != address(0), "Invalid address");

        require(hasNFTAndERC20Token(voterAddress), "You must have the required NFT and ERC20 token to vote");

        // Check if voter already exists
        if ( s.Voters[voterAddress].verified == false ) {
            // Create a new VotersDetails struct for the voter

            VotersDetails storage newVotersDetails = s.Voters[voterAddress];

            newVotersDetails.voterAddress = voterAddress;
            newVotersDetails.hasVoted = false;
            newVotersDetails.vote = false;
            newVotersDetails.verified = true;
            
        }

        // Check if the voter is not already in the eligible voter array
        for (uint256 i = 0; i < s.EligibleVoters.length; i++) {
            require(s.EligibleVoters[i] != voterAddress, "Voter is already eligible");
        }

        // Add the voter to the array
        s.EligibleVoters.push(voterAddress);

        s._totalVoters++;
    }

    function getRandomVoters() public {
        require(s._totalVoters >= 3, "Not enough voters to select from");

        uint256[] memory randomIndices = _generateRandomIndices(3, s._totalVoters);

        // get 3 random voters with details from voters mapping
        for (uint256 i = 0; i < randomIndices.length; i++) {
            // uint256 randomIndex = randomIndices[i];
            address selectedVoter = s.Voters[msg.sender].voterAddress;
            s.EligibleVoters.push(selectedVoter);
        }
    }

    function getContent(uint256 contentID) public view returns (Content memory) {
        return s.ContentBank[contentID];
    }

    function startVoting() public returns (bool) {
       return s._isVotingOn = true;
    }

    function stopVoting() public returns (bool) {
       return s._isVotingOn = false;
    }


    function vote(bool voteValue, uint256 contentID) public {

        // checks if voting time is on, if not, don't allow to vote
        require(s._isVotingOn, "Wait for voting time please!");

        // if voting time is off, start voting 
        if (s._votingTime > block.timestamp) {
            s._isVotingOn = true;
           s._votingTime = block.timestamp;
        }

        // checks that the voters are in eligible voters array
        require(isEligibleVoter(msg.sender), "You are not eligible to vote");
        

        //require that voters have NFT and ERC20 token in their wallet
         require(hasNFTAndERC20Token(msg.sender), "You must have the required NFT and ERC20 token to vote");

        // check if voter has already voted
        VotersDetails memory voter = s.Voters[msg.sender];
        require(voter.hasVoted == false, "You have already voted");

        //allow them cast a yes or no vote
        voter.hasVoted = true;
        voter.vote = voteValue;

        Content storage updateContent = s.ContentBank[contentID];

        // increment votes count for either yes or no votes
        if (voteValue) {
            updateContent.yesVotes++;
        } else {
            updateContent.noVotes++;
        }

        updateContent.isVotedOn = true;

        updateContent.totalVoteCount++;

       
        // Stop voting time if all eligible voters have voted
        if (allVotersHaveVoted()) {
            s._isVotingOn = false;
            s._votingTime = 0;
        }

        // Stop voting time if vote time elapses
        // if (block.timestamp >= s._votingTime + 1 hours) {
        //    s._isVotingOn = false;
        // }

        emit VoteCast(msg.sender, voteValue);
    }

    function isEligibleVoter(address voter) internal view returns (bool) {
    // Iterate through the eligible voters array to check if the given address is present
        for (uint256 i = 0; i < s.EligibleVoters.length; i++) {
            if (s.EligibleVoters[i] == voter) {
                // If the given address is found in the array, return true (i.e., the voter is eligible)
                return true;
            }
        }

        // If the given address is not found in the array, return false (i.e., the voter is not eligible)
        return false;
    }

    // check if the given address has the required NFT and ERC20 token in their wallet
    function hasNFTAndERC20Token(address voter) internal view returns (bool) {

    // Check if the voter owns the NFT
    bool hasNFT = IERC721(s._nftAddress).balanceOf(voter) > 0; 

    // Check if the voter has the ERC20 token balance
    uint256 erc20Balance = IERC20(s._tokenAddress).balanceOf(voter); 

    return hasNFT && (erc20Balance > 0);

    // return (erc20Balance > 0);
    }



    function getVoterIndex(address voter) internal view returns (uint256) {
        // Implement the logic to retrieve the index of the given voter address
        // from the eligibleVoters array
        for (uint256 i = 0; i < s.EligibleVoters.length; i++) {
            if (s.EligibleVoters[i] == voter) {
                return i;
            }
        }
        revert("Voter not found");
    }

    function allVotersHaveVoted() internal view returns (bool) {
        // Iterate through the eligible voters array and check their voting status
        for (uint256 i = 0; i < s.EligibleVoters.length; i++) {
            address voter = s.EligibleVoters[i];
            if (!s.Voters[voter].hasVoted) {
                // If any eligible voter has not voted, return false
                return false;
            }
        }

        // If all eligible voters have voted, return true
        return true;
    }

    function _generateRandomIndices(uint256 count, uint256 max) internal view returns (uint256[] memory) {
    require(count <= max, "Count must be less than or equal to the maximum");

    uint256[] memory indices = new uint256[](count);
    uint256 lastIndex = max - 1;

    for (uint256 i = 0; i < count; i++) {
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.timestamp, i))) % (lastIndex + 1);
        indices[i] = randomIndex;

        // Swap the chosen index with the last index to avoid duplicates
        lastIndex--;
        if (randomIndex != lastIndex) {
            _swap(indices, randomIndex, lastIndex);
        }
    }

    return indices;
    
    }

    function _swap(uint256[] memory array, uint256 index1, uint256 index2) internal pure {
        uint256 temp = array[index1];
        array[index1] = array[index2];
        array[index2] = temp;
    }



}