// const { Wallet, Provider, utils } = require("zksync-web3");
// const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");

// async function main() {
//   const wallet = new Wallet("Wallet-Private-Key"); 

//   const deployer = new Deployer(hre, wallet);

//   // Load the compiled contract artifact
//   const artifact = await deployer.loadArtifact("TwikklNFT");

//   // Deploy the contract
//   const contract = await deployer.deploy(artifact);

//   console.log(`Contract deployed at address: ${contract.address}`);
// }

// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
