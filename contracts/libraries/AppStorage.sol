// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct ERC20AppStorage {

    // Twikkle Token 
    uint256  totalSupply;

    string  name;

    string  symbol;

    uint8 decimals;

    mapping(address => mapping(address => uint256)) allowances;

    mapping(address => uint256) balances; 


}

struct ERC721AppStorage {

   // Twikle NFT name
    string name;

    // Twikle symbol
    string symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) owners;

    // Mapping owner address to token count
    mapping(address => uint256) balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address)  tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) operatorApprovals;

}


struct Content {

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

struct flaggedContent {

      uint256 contentID;

      uint256 flaggedTimestamp;

      address flaggedBy;

}

struct VotersDetails {

      address voterAddress;

      bool hasVoted;

      bool vote;
      
}


struct AppStorage {

    // FlagContent Facet

    address _tokenAddress;

    address _nftAddress;

    uint256 _totalFlaggedContent;

    uint256 _voteCount;

    uint256 _votingTime;

    uint256 _totalVoters;

    bool _isVotingOn;

mapping(uint256 => Content) ContentBank;

// mapping(address => bool) EligibleVoters;

address[] EligibleVoters;

mapping (address => VotersDetails) Voters;

mapping(uint256 => flaggedContent) flaggedContents;

}