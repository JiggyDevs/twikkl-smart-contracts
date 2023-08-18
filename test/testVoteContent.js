const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe ("VoteContractFacet", function () {
  async function deployTokenContract() {

    const contentId = 1;

    const [owner, voter1, voter2, voter3, voter4] = await ethers.getSigners();
   
       // deploy Twikkl token
       const TwikklToken = await ethers.getContractFactory("TwikklToken");
       const twikklToken = await TwikklToken.deploy();
       await twikklToken.deployed();
   
       // Mint Twikkl token to voter1
       await twikklToken.withdrawFromContract(voter1.address, BigInt(1));

       // Mint Twikkl token to voter2
       await twikklToken.withdrawFromContract(voter2.address, BigInt(1));

       // Mint Twikkl token to voter3
       await twikklToken.withdrawFromContract(voter3.address, BigInt(1));

   
       // deploy TwikklNFT
       const TwikklNFT = await ethers.getContractFactory("TwikklNFT");
       const twikklNFT = await TwikklNFT.deploy();
       await twikklNFT.deployed();
   
       // Mint TwikklNFT 

       // Get the NFT Metadata IPFS URL
       const tokenUri = "https://gateway.pinata.cloud/ipfs/QmZKMnmVLre9c9cxKCd4DXZzv6etAtQQrryDGMKtsRaqNR"
   
       // Mint TwikklNFT token to voter1
       await twikklNFT.mintNFT(voter1.address, tokenUri);

       // Mint TwikklNFT token to voter2
       await twikklNFT.mintNFT(voter2.address, tokenUri);

       // Mint TwikklNFT token to voter3
       await twikklNFT.mintNFT(voter3.address, tokenUri);
   
       // deploy Vote Content Facet Bank
       const VoteContentFacet = await ethers.getContractFactory("VoteContentFacet");
       const voteContent = await VoteContentFacet.deploy();
   
       await voteContent.deployed();
   
       return { 
        owner, 
        voter1, 
        voter2, 
        voter3, 
        twikklNFT, 
        twikklToken, 
        voteContent, 
        contentId,
      };
    
  }

  describe("Commence Content Voting", function() {
    it ("Check if twikklNFT & twikklToken exists", async function() {

      const {twikklNFT, twikklToken } = await loadFixture
      (deployTokenContract);

      console.log("NFT", twikklNFT.address);

      console.log("Token", twikklToken.address)

    })

    it ("Ensure that voting has started", async function() {

      const { voteContent } = await loadFixture
      (deployTokenContract);
      
      await voteContent.startVoting();

      expect(await voteContent.isVotingOn()).to.equal(true);

    })

    it ("Check current no of voters", async function () {
      const { voteContent } = await loadFixture
      (deployTokenContract);

      const noOfVoters = await voteContent.totalVoters();
      
      console.log("noOfVoters", noOfVoters);
    });

    it ("Test to ensure voters vote", async function () {
      const {voter1, voter2,
      voter3, voter4, 
      voteContent, contentId, twikklNFT, twikklToken} = await loadFixture
      (deployTokenContract);

      await voteContent.startVoting();
      
      await voteContent.setNFTAdress(twikklNFT.address);

      await voteContent.setTokenAdress(twikklToken.address)

      await voteContent.addVoters(voter1.address);

      await voteContent.addVoters(voter2.address);

      await voteContent.addVoters(voter3.address);

      await voteContent.connect(voter1).vote(true, contentId);

      await voteContent.connect(voter2).vote(true, contentId);
      
      await voteContent.connect(voter3).vote(true, contentId);

      // await voteContent.connect(voter4).vote(true, contentId);

      const noOfVoters = await voteContent.totalVoters();
      
      // console.log("New number Of Voters", noOfVoters);

      
      const content = await voteContent.getContent(contentId)

      // console.log("content", content);

    });

    
  })

}) 
