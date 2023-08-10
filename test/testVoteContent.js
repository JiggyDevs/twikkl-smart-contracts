const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");
const  { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const helpers = require("@nomicfoundation/hardhat-network-helpers");


async function deployTokenContract() {

 const [owner, user1, user2, protocol] = await ethers.getSigners();

    // deploy Twikkl token
    const TwikklToken = await ethers.getContractFactory("TwikklToken");
    const twikklToken = await TwikklToken.deploy();
    await twikklToken.deployed();

    // Mint Twikkl token to user1
    await twikklToken.withdrawFromContract(user1.address, BigInt(1e23));

    // deploy TwikklNFT
    const TwikklNFT = await ethers.getContractFactory("TwikklNFT");
    const twikklNFT = await TwikklNFT.deploy();
    await twikklNFT.deployed();

    // Mint TwikklNFT token to user1
    // Get the NFT Metadata IPFS URL
    const tokenUri = "https://gateway.pinata.cloud/ipfs/QmZKMnmVLre9c9cxKCd4DXZzv6etAtQQrryDGMKtsRaqNR"

    await twikklNFT.mintNFT(user1.address, tokenUri);

    // deploy Vote Content Facet Bank
    const VoteContentFacet = await ethers.getContractFactory("VoteContentFacet");
    const voteContent = await VoteContentFacet.deploy();

    await voteContent.deployed();

    // Call the vote function
    await voteContent.vote(
      yes,
      "x2nbhfjf"
    );

    return { owner, user1, user2, twikklNFT, twikklToken, voteContent, protocol };
 
}