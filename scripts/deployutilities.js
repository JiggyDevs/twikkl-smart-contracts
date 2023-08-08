const { ethers } = require("hardhat");

async function main() {

  //
  // ------- Deploy NFT --------
  //

  const TwikklNFT = await ethers.getContractFactory("TwikklNFT");
  const twikklNFT = await TwikklNFT.deploy();

  await twikklNFT.deployed();

  console.log("TwikklNFT deployed to:", twikklNFT.address);
  
  //
  // ------ Deploy Token -------
  //
  const TwikklToken = await ethers.getContractFactory("TwikklToken");
  const twikklToken = await TwikklToken.deploy();

  await twikklToken.deployed();

  console.log("TwikklToken deployed to:", twikklToken.address);

  // -------  Transfer Tokens  -------

  // const TwikklTokenTransfer = await ethers.getContractAt("TwikklToken", twikklToken.address);

  // transfer tokens from TwikklToken.sol contract to  address
  // const transfer = await TwikklTokenTransfer.withdrawFromContract(address(this), "20000000000000000000");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});