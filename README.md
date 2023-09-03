# Welcome To Twikkl Smart Contracts!

Twikkle smart contracts consist of User-content Flaging and Restriction smart contracts. The contracts implement the EIP-2535 Diamonds standard, which allows for modular upgradeability.

Twikkle is a decentralized video sharing app with social services and more.

We also have one of the frenliest communities in crypto, so don't hesitate to hop in!

Twikkle Discord: https://discord.gg/dAxGUfss


## Deployed Contract Addresses:

Twikkle smart contract was deployed on the Sepolia blockchain. Below are the deployed Diamond addresses:

TwikklToken deployed to: 0x50886AB774220706744394F351ee468952eC6112

TwikklNFT deployed to: 0x5fb238aDe346aD2e0943bA5F793d94575F301603

DiamondCutFacet deployed: 0xcf4CD5d6B6c7820b6aEE616E86EE06CCdBbBd041<br>

Diamond deployed: 0x67b14a18AE7418B934510A09BBc67547ae538c17<br>

DiamondInit deployed: 0x6737CaAf13D3b1967613c7456025B9a40Fab395c<br>

DiamondLoupeFacet deployed: 0x72733f8529D26AAd7ef58f32FA8D075A78aBE1F4<br>

OwnershipFacet deployed: 0xE73243df409723360903Df7389D1927806c5Cc55<br>

VoteContentFacet deployed: 0xa15c9BB409F780379A57d3a9e9a74e6B348D5e19<br>

FlagContentFacet deployed: 0xd143Ee48FB75CC1c8D5fE2b07375Aa6aeC34D2ea<br>

MerkleTreeFacet deployed: 0x549dC79b8cbd24DFd0aEB7dc030DdCA4494D73EB<br>


## Resources
Official docs: Coming soon!

Louper Dev Diamond Explorer: https://louper.dev/diamond/0x67b14a18AE7418B934510A09BBc67547ae538c17?network=sepolia

Official Subgraph: Coming soon!

EIP2535 Primer: https://eips.ethereum.org/EIPS/eip-2535


## Installation

- Clone this repo
- Install dependencies

```bash
$ yarn && forge update
```

### Compile

```bash
$ npx hardhat compile
```

## Deployment

### Hardhat

```bash
$ npx hardhat run scripts/deploy.js
```

### Foundry

```bash
$ forge t
```

`Note`: A lot of improvements are still needed so contributions are welcome!!

Bonus: The [DiamondLoupefacet](contracts/facets/DiamondLoupeFacet.sol) uses an updated [LibDiamond](contracts/libraries//LibDiamond.sol) which utilises solidity custom errors to make debugging easier especially when upgrading diamonds. Take it for a spin!!


