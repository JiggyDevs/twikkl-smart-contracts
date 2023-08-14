const { expect } = require("chai");
const { ethers } = require("hardhat");
const helpers = require("@nomicfoundation/hardhat-network-helpers");


describe ("VoteContractFacet", function () {
  let voteContentFacet;
  let mockNFT;
  let mockERC20;
  let owner;
  let voter1;
  let voter2;
  let voter3;
  let contentId;

  beforeEach(async function () {
    const VoteContentFacet = await ethers.getContractFactory("VoteContentFacet");
    voteContentFacet = await VoteContentFacet.deploy();
    await voteContentFacet.deployed();

    // Deploy mock NFT contract
    const MockNFT = await ethers.getContractFactory("TwikklNFT");
    mockNFT = await MockNFT.deploy();
    await mockNFT.deployed();

    // Deploy mock ERC20 contract
    const MockERC20 = await ethers.getContractFactory("TwikklToken");
    mockERC20 = await MockERC20.deploy();
    await mockERC20.deployed();

    [owner, voter1, voter2, voter3] = await ethers.getSigners();

     // Get the NFT Metadata IPFS URL
     const tokenUri = "https://gateway.pinata.cloud/ipfs/QmZKMnmVLre9c9cxKCd4DXZzv6etAtQQrryDGMKtsRaqNR"

    // Mint NFT for voter1
    await mockNFT.mintNFT(voter1.address, tokenUri);

    // Mint NFT for voter2
    await mockNFT.mintNFT(voter2.address, tokenUri);

    // Mint NFT for voter3
    await mockNFT.mintNFT(voter3.address, tokenUri);

    // Add voters to the contract
    await voteContentFacet.addVoters(voter1.address);
    await voteContentFacet.addVoters(voter2.address);
    await voteContentFacet.addVoters(voter3.address);

    // Set up a mock content
    contentId = 1;

    // start voting process 
    await voteContentFacet.startVoting();

    await voteContentFacet.connect(voter1).vote(true, contentId);
  });

  // it("should check numbers of voters", async function () {
  //   expect(await voteContentFacet.totalVoters()).to.equal(3);

    
  //   console.log("checked numbers of voters");
  // });
  
  
      
  // it("should add voters", async function () {
  //   expect(await voteContentFacet.totalVoters()).to.equal(3);
  // });

  it("should get total flagged content", async function () {
    expect(await voteContentFacet.totalFlaggedContent()).to.equal(0);
  });

  // it("should check numbers of voters", async function () {
  //   expect(await voteContentFacet.totalVoters()).to.equal(3);

    
  //   console.log("checked numbers of voters");
  // });

  // it("should check numbers of voters", async function () {
  //   voteContentFacet.startVoting();

  //   expect(await voteContentFacet.startVoting()).to.equal(true);

    
  //   console.log("Voting is on now");
  // });

  it("should allow eligible voters to vote", async function () {
    await voteContentFacet.getRandomVoters();
    await mockERC20.transfer(voter1.address, 100);
    await mockERC20.connect(voter1).approve(voteContentFacet.address, 100);

    await voteContentFacet.connect(voter1).vote(true, contentId);
    expect((await voteContentFacet.totalVoters()).toString()).to.equal("3");
  });

  it("should not allow non-eligible voters to vote", async function () {
    await expect(voteContentFacet.connect(owner).vote(true, contentId)).to.be.revertedWith(
      "You are not eligible to vote"
    );
  });

  it("should not allow duplicate votes", async function () {
    await voteContentFacet.getRandomVoters();
    await mockERC20.transfer(voter1.address, 100);
    await mockERC20.connect(voter1).approve(voteContentFacet.address, 100);

    await voteContentFacet.connect(voter1).vote(true, contentId);
    await expect(voteContentFacet.connect(voter1).vote(true, contentId)).to.be.revertedWith(
      "You have already voted"
    );
  });







})