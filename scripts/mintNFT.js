require('dotenv').config();
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

// Get contract ABI and address
const abi = contract.abi
const contractAddress = '0xA4766Ceb9E84a71D282A4CED9fB8Fe93C49b2Ff7'

// Create a contract instance
const myNftContract = new ethers.Contract(contractAddress, abi, signer)

// Get the NFT Metadata IPFS URL
const tokenUri = "https://gateway.pinata.cloud/ipfs/QmZKMnmVLre9c9cxKCd4DXZzv6etAtQQrryDGMKtsRaqNR"

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