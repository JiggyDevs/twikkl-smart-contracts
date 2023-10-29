// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";

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

struct redFlaggedContent {

      uint256 contentID;

      uint256 flaggedTimestamp;

      address flaggedBy;

}

struct VotersDetails {

      address voterAddress;

      bool verified;

      mapping(uint256 => bool) hasVotedOnContent;
      
}


struct AppStorage {

    // FlagContent Facet

    address _jiggyTokenAddress;
    
    address _membershipNftAddress;

    address _validatorNftAddress;

    uint256 _totalFlaggedContent; 

    uint256 _totalRedFlaggedContent;

    uint256 _totalVoters;

    uint256  votingDeadline; 
    
    bool _isVotingOn;

mapping(uint256 => Content) ContentBank;

mapping (address => VotersDetails) Voters;

mapping(uint256 => redFlaggedContent) redFlaggedContents;

mapping(address => mapping(uint256 => bool)) validatorsVotes;

mapping(address => mapping(uint256 => bool)) generalVotes;

}

contract Modifiers {
    modifier onlyOwner() {
        address owner = LibDiamond.contractOwner();
        require(owner == msg.sender, "Only Owner can call this function");
        _;
    }  
}