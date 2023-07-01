import { ethers } from "hardhat";

async function main() {

  const MerkleTreeNFT = await ethers.getContractFactory("MerkleTreeNFT");
  const merkleTree = await MerkleTree.deploy("input merkleroot");

  await merkleTree.deployed();

  console.log("MerkleTreeNFT deployed to:", merkleTree.address);

// merkleTree.methods.safeMint(address, proof).send({ from: address })

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});