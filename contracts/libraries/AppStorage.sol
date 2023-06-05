// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct AppStorage {

    Token address public _tokenAddress;

    NFT address public _nftAddress;

    uint256 public _totalFlaggedContent;

    uint256 public _voteCount;

    uint256 public _votingTime;

    bool public _isVotingOn;

    address[] public EligibleVoters;

    struct public Content {
      string contentName;

      address contentCreator;

      uint256 contentID;

      bool flagged;

      uint256 flaggedTimestamp;
      
      address flaggedBy;

      string reasonForFlagging;

      string contentDescription;

      bool isVotedOn;

      address[] voters;

      uint256 totalVoteCount;

      uint256 flaggedVotes;

      uint256 yesVotes;

      uint256 noVotes;

    }

    struct public flaggedContent {

      uint256 contentID;

      uint256 flaggedTimestamp;

      address flaggedBy;


    }

    struct public _VotersDetails {

      address public _voterAddress;

      bool public _hasVote;

      bool public _vote;
      
    }

    mapping (address => _VotersDetails) _Votes;

    mapping(uint256 => flaggedContent) public flaggedContents;
}