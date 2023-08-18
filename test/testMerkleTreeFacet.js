// Import required modules
const { expect } = require('chai');
const { keccak256 } = require('ethers/lib/utils');
const { ethers } = require('hardhat');
const { MerkleTree } = require('merkletreejs');

describe('MerkleTreeFacet', function () {
  let merkleTreeFacet;
  let owner, user1, user2;
  const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

  beforeEach(async function () {
    [owner, user1, user2] = await ethers.getSigners();

    const MerkleTreeFacet = await ethers.getContractFactory('MerkleTreeFacet');
    merkleTreeFacet = await MerkleTreeFacet.deploy();
    await merkleTreeFacet.deployed();
  });

  it('should create merkle tree', async function () {
    const leaves = [user1.address, user2.address].map(x => keccak256(x));
    const tree = new MerkleTree(leaves, keccak256);
  })

  it('should set merkle root hash', async function () {
    const leaves = [user1.address, user2.address].map(x => keccak256(x));
    const tree = new MerkleTree(leaves, keccak256);

    const newMerkleRoot = tree.getRoot();
    // .toString('hex')
    // console.log('newMerkleRoot', newMerkleRoot);
    
    await merkleTreeFacet.connect(owner).setMerkleRoot(newMerkleRoot);

    const storedMerkleRoot = await merkleTreeFacet.merkleRoot();

    const MerkleRoot = await merkleTreeFacet.getMerkleRoot()

    expect(storedMerkleRoot).to.equal(MerkleRoot);
  });

  it('should verify merkle proof for whitelisted address', async function () {

    const leaves = [user1.address, user2.address].map(x => keccak256(x));

    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

    const newMerkleRoot = tree.getRoot();
    // .toString('hex')
    
    await merkleTreeFacet.connect(owner).setMerkleRoot(newMerkleRoot);

    const leaf = keccak256(user1.address);
   
    const proof = tree.getHexProof(leaf);

    const result = await merkleTreeFacet.connect(user1.address).verifyAddress(proof);

    // console.log("verify", tree.verify(proof, leaf, newMerkleRoot));
    expect(result).to.equal(true);
  });
  
  it('should reject invalid merkle proof for whitelisted address', async function () {
    
    const leaves = [user1.address, user2.address].map(x => keccak256(x));

    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

    const newMerkleRoot = tree.getRoot();
    // .toString('hex')
    
    await merkleTreeFacet.connect(owner).setMerkleRoot(newMerkleRoot);

    const leaf = keccak256(owner.address);
   
    const invalidProof = tree.getHexProof(leaf);

    const result = await merkleTreeFacet.connect(owner).verifyAddress(invalidProof);

    expect(result).to.equal(false);
  });

  it('should allow whitelisted address to call whitelistFunc', async function () {
    const leaves = [user1.address, user2.address].map(x => keccak256(x));

    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

    const newMerkleRoot = tree.getRoot();
    // .toString('hex')
    
    await merkleTreeFacet.connect(owner).setMerkleRoot(newMerkleRoot);

    const leaf = keccak256(user1.address);
   
    const proof = tree.getHexProof(leaf);

    const result = await merkleTreeFacet.connect(user1.address).whitelistFunc(proof);

    console.log("result", result);

    // await expect(merkleTreeFacet.connect(user1.address).whitelistFunc(proof)).to.not.be.reverted;
  });

  it('should reject non-whitelisted address from calling whitelistFunc', async function () {
    const leaves = [user1.address, user2.address].map(x => keccak256(x));

    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });

    const newMerkleRoot = tree.getRoot();
    // .toString('hex')
    
    await merkleTreeFacet.connect(owner).setMerkleRoot(newMerkleRoot);

    const leaf = keccak256(user1.address);
   
    const proof = tree.getHexProof(leaf);

    const result = await merkleTreeFacet.connect(user1.address).whitelistFunc(proof);

    console.log("result", result);
    // expect(result).to.equal([ ]);
  });
});
