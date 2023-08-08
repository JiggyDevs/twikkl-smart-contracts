// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {AppStorage, flaggedContent} from "../libraries/AppStorage.sol";

import "./MerkleTreeFacet.sol";

contract FlagContentFacet  {
    
    AppStorage internal s;

    MerkleTreeFacet private merkleTreeFacet;

    // sets the address of the merkleTreeFacet
    // function initialize(address merkleTreeFacetAddress) external {
    // merkleTreeFacet = MerkleTreeFacet(merkleTreeFacetAddress);
    // }

    // The function to flag content.
    function FlagContent(uint256 _contentID) public {

    // Check if the user has the correct permissions to flag content(merkle tree).
    // bytes32[] calldata merkleProof = new bytes32[](3);
    // merkleProof[0] = keccak256(msg.sender);
    // merkleProof[1] = keccak256(merkleTreeFacet.merkleRoot);
    // merkleProof[2] = keccak256(merkleTreeFacet.merkleRoot);

    // To-Fix: complier issue - verifyAddress not found
    // require(merkleTreeFacet.verifyAddress(merkleProof), "No permission to flag content.");


    // Create a new flaggedContent struct and store it in the mapping.

    flaggedContent memory newFlaggedContent = flaggedContent({
      
      contentID : _contentID,
       
      flaggedTimestamp : block.timestamp,

      flaggedBy : msg.sender

    
    });

    s.flaggedContents[_contentID] = newFlaggedContent;

    s._totalFlaggedContent ++;

  }
    
}