const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");
const  { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const helpers = require("@nomicfoundation/hardhat-network-helpers");

describe ("VoteContractFacet", function () {
  async function deployTokenContract() {

    const [owner, user1, user2, user3, user4, protocol] = await ethers.getSigners();
   
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
      //  await voteContent.vote(
      //    "yes",
      //    "100000"
      //  );
   
       return { owner, user1, user2, user3, user4, twikklNFT, twikklToken, voteContent, protocol };
    
  }
  
  describe("Test that vote function works", function() {
    it ("Ensure that user can vote", async function () {
      const {user1, voteContent } = await loadFixture
      (deployTokenContract);

      console.log("user1", user1.address);

      const vote = await voteContent.addVoters(user1.address);

      // console.log("voters",vote)
      const noOfVoters = await voteContent.totalVoters();
      
      // console.log("noOfVoters", noOfVoters);
      //  let noOfVoters = await voteContent._totalVoters;
      // expect(noOfVoters).to.equal(1);
    });
  })

  // describe("Test that Voting can be done ", function() {
  //   it ("Ensure that isVotingOn is false before voting can be cast", async function () {
  //     const {user1, voteContent } = await loadFixture
  //     (deployTokenContract);

  //     console.log(user1.address);

  //     const checker = await voteContent.addVoters(user1.address);

  //     const noOfVoters = await voteContent.totalVoters;
       
  //     console.log("checker", checker);
  //     console.log("noOfVoters", noOfVoters);
  //     //  let noOfVoters = await voteContent._totalVoters;
  //     // expect(noOfVoters).to.equal(1);
  //   });
  // })
}) 
