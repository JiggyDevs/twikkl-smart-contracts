// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleTreeWhitelist is Ownable {

  /**
  * @notice Merkle root hash for whitelist addresses
  */
  bytes32 public merkleRoot;

  /**
  * @notice Change merkle root hash
  */
  function setMerkleRoot(bytes32 merkleRootHash) external onlyOwner
  {
      merkleRoot = merkleRootHash;
  }

  /**
  * @notice Verify merkle proof of the address
  */
  function verifyAddress(bytes32[] calldata _merkleProof) private 
  view returns (bool) {
      bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
      return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
  }

  /**
  * @notice Function with whitelist
  */
  function whitelistFunc(bytes32[] calldata _merkleProof) external
  {
      require(verifyAddress(_merkleProof), "INVALID_PROOF");

      // Do some useful stuff
  }

}