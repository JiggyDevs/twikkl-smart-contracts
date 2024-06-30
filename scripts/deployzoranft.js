const { ethers } = require("hardhat");

async function main() {

  //
  // ------- Deploy NFT --------
  //

  const MyZoraNFT = await ethers.getContractFactory("MyZoraNFT");
  const zoraNFT = await MyZoraNFT.deploy();

  await zoraNFT.deployed();

  console.log("MyZoraNFT deployed to:", zoraNFT.address);

  console.log(MyZoraNFT);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});