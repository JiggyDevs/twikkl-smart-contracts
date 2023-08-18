// Import required dependencies
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("FlagContentFacet", function () {
  // Define variables to hold contract instances
  let flagContentFacet;
  let contentId = 123;
  let user;

  // Deploy the contracts before each test
  beforeEach(async function () {
    [deployer, user, unauthorizedUser] = await ethers.getSigners();

    const FlagContentFacet = await ethers.getContractFactory("FlagContentFacet");
    flagContentFacet = await FlagContentFacet.deploy();
    await flagContentFacet.deployed();

  });
  

  // Test the FlagContent function
  it("should flag content", async function () {
    // Call the FlagContent function
    const result = await flagContentFacet.connect(user).FlagContent(contentId);

  });

  // Test the FlagContent function
  it("should not flag invalid content", async function () {

      // Attempt to flag invalid content
    try {
      await flagContentFacet.connect(user).FlagContent(0);
      // The line above should throw an error, so we don't expect to reach this point
      expect.fail("Expected an error but function succeeded");
    } catch (error) {
      // Ensure that the error message contains "Flag valid content!"
      expect(error.message).to.include("Flag valid content!");
    }

  });

  // Test that only authorized users can flag content
  it("Check if the content was flagged correctly", async function () {
   
    // Call the FlagContent function
    await flagContentFacet.connect(user).FlagContent(contentId);

    const content = await flagContentFacet.getFlaggedContent(contentId)

    expect(content.flaggedBy).to.equal(user.address);

  });
});
