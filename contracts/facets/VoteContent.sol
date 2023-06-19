// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../libraries/AppStorage.sol";

contract VoteContent  {
    AppStorage internal s;

    event VoteCast(address indexed voter, bool vote);

    function getRandomVoters() public {
        require(s.totalVoters >= 3, "Not enough voters to select from");

        uint256[] memory randomIndices = _generateRandomIndices(3, s.totalVoters);

        // get 3 random voters with details from voters mapping
        for (uint256 i = 0; i < randomIndices.length; i++) {
            uint256 randomIndex = randomIndices[i];
            address selectedVoter = voters[randomIndex].voterAddress;
            s.EligibleVoters[selectedVoter] = true;
        }
    }


    function vote(bool voteValue) public {

        // checks if voting time is on, if not, dont allow to vote
        require(!s._isVotingOn, "Wait for voting time please!");

        // if voting time is off, start voting vote
        if (!s._votingTime) {
            s._isVotingOn = true;
           s._votingTime = block.timestamp;
        }

        // checks that the voters are in eligible voters array
        require(isEligibleVoter(msg.sender), "You are not eligible to vote");
        

        //require that voters have NFT and ERC20 token in their wallet
         require(hasNFTAndERC20Token(msg.sender), "You must have the required NFT and ERC20 token to vote");

        // check if voter has already voted
        VoterDetails storage voter = voters[getVoterIndex(msg.sender)];
        require(!s.voter.hasVoted, "You have already voted");

        //allow them cast a yes or no vote
        s.voter.hasVoted = true;
        s.voter.vote = voteValue;

        // increment votes count for either yes or no votes
        if (voteValue) {
            s.yesVotes++;
        } else {
            s.noVotes++;
        }

        // stop voting time

        // Stop voting time if all eligible voters have voted
        if (allVotersHaveVoted()) {
            s.isVotingOn = false;
            s._votingTime = 0
        }

        // Stop voting time if vote time elapses
        // if (block.timestamp >= s._votingTime + 1 hours) {
        //    s._isVotingOn = false;
        // }

        emit VoteCast(msg.sender, voteValue);
    }

    function isEligibleVoter(address voter) internal view returns (bool) {
        // Logic to check if the given address is an eligible voter by verifying if it exists in the eligibleVoters mapping
        return s.EligibleVoters[voter];
    }

    // check if the given address has the required NFT and ERC20 token in their wallet
    function hasNFTAndERC20Token(address voter) internal view returns (bool) {

    // Check if the voter owns the NFT
    bool hasNFT = YourNFTContract(s._nftAddress).ownerOf(tokenId) == voter; 

    // Check if the voter has the ERC20 token balance
    uint256 erc20Balance = YourERC20Contract(s._tokenAddress).balanceOf(voter); 

    return hasNFT && (erc20Balance > 0);
    }


    function getVoterIndex(address voter) internal view returns (uint256) {
        // Implement the logic to retrieve the index of the given voter address
        // from the voters mapping
        for (uint256 i = 0; i < s.totalVoters; i++) {
            if (s.voters[i].voterAddress == voter) {
                return i;
            }
        }
        revert("Voter not found");
    }

    function allVotersHaveVoted() internal view returns (bool) {
        // logic to check if all eligible voters have voted by iterating through the eligibleVoters mapping and checking their voting status
        for (address voter : s.EligibleVoters) {
            if (!voters[voter].hasVoted) {
                return false;
            }
        }
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