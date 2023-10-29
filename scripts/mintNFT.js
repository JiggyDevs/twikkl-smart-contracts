require("dotenv").config({ path: ".env" });
const ethers = require('ethers');

// Get Alchemy SEPOLIA API  URL
const API_KEY = process.env.ALCHEMY_SEPOLIA_API_KEY;

// Define an Alchemy Provider
const provider = new ethers.providers.AlchemyProvider('sepolia', API_KEY)

// Get contract ABI file
const contract = require("../artifacts/contracts/MyNFT.sol/MyNFT.json");

// Create a signer
const privateKey = process.env.ACCOUNT_PRIVATE_KEY
const signer = new ethers.Wallet(privateKey, provider)
const TOKENURI = process.env.TOKENURI


// Get contract ABI and address
const abi = contract.abi
const contractAddress = process.env.DEPLOYED_NFT_CONTRACT

// Create a contract instance
const myNftContract = new ethers.Contract(contractAddress, abi, signer)

// Get the NFT Metadata IPFS URL
const tokenUri = `https://gateway.pinata.cloud/ipfs/${TOKENURI}`

// Call mintNFT function
const mintNFT = async () => {
    let nftTxn = await myNftContract.mintNFT(signer.address, tokenUri)
    await nftTxn.wait()
    console.log(`NFT Minted! Check it out at: https://sepolia.etherscan.io/tx/${nftTxn.hash}`)
}

mintNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });