// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {Modifiers} from "../libraries/AppStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
 * @title MerkleTreeFacet
 * @dev A smart contract for managing a Merkle tree-based whitelist.
 */

contract MerkleTreeFacet is Modifiers {

  /**
  * @notice Merkle root hash for whitelist addresses
  */
  bytes32 public merkleRoot;

  /**
     * @notice Get the current Merkle root hash.
     * @return The current Merkle root hash.
     */
  function getMerkleRoot() external view returns (bytes32)  {
     return merkleRoot;
  }

   /**
     * @notice Change the Merkle root hash. Only the contract owner can call this function.
     * @param merkleRootHash The new Merkle root hash.
     */
  function setMerkleRoot(bytes32 merkleRootHash) internal onlyOwner
  {
      merkleRoot = merkleRootHash;
  }

  /**
     * @notice Verify a Merkle proof for an address.
     * @param _merkleProof The Merkle proof for the address.
     * @return A boolean indicating whether the proof is valid.
     */
  function verifyAddress(bytes32[] calldata _merkleProof) public 
  view returns (bool) {
      bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
      return MerkleProof.verifyCalldata(_merkleProof, merkleRoot, leaf);
  }

  /**
     * @notice Perform an operation using the whitelist. Requires a valid Merkle proof.
     * @param _merkleProof The Merkle proof for the caller's address.
     * @dev Reverts if the Merkle proof is invalid.
     */
  function whitelistFunc(bytes32[] calldata _merkleProof) external view
  {
      require(verifyAddress(_merkleProof), "INVALID_PROOF");

  }

}