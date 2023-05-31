// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

struct AppStorage {

    Token address public _tokenAddress;

    NFT address public _nftAddress;

    uint256 public _voteCount;

    uint256 public _votingTime;

    bool public _isVotingOn;

    address[] public EligibleVoters;

    struct public VotersDetails {

      address public _voterAddress;

      bool public _hasVote;

      bool public _vote;
      
    }

    
    mapping(address => uint256)  _balances;

    mapping(address => mapping(address => uint256))  _allowances;

    uint256  _totalSupply;

    string  _name;

    string  _symbol;

    uint8 _decimal;
}