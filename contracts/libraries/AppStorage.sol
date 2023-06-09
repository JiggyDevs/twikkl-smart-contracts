// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct AppStorage {

   // Twikkle Token 

    uint256  _totalSupply;

    string  _name;

    string  _symbol;

    uint8 _decimal;

    mapping(address => mapping(address => uint256)) allowances;

    mapping(address => uint256) balances;  


    // FlagContent Facet

    Token address public _tokenAddress;

    NFT address public _nftAddress;

    uint256 public _totalFlaggedContent;

    uint256 public _voteCount;

    uint256 public _votingTime;

    uint256 public _totalVoters;

    bool public _isVotingOn;

    mapping(address => bool) public EligibleVoters;

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

    mapping (uint256 => _VotersDetails) _Voters;

    mapping(uint256 => flaggedContent) public flaggedContents;
}