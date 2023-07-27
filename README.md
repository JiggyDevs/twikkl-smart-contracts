# Welcome To Twikkl Smart Contracts!

Twikkle smart contracts consist of User-content Flaging and Restriction smart contracts. The contracts implement the EIP-2535 Diamonds standard, which allows for modular upgradeability.

Twikkle is a decentralized video sharing app with social services and more.

We also have one of the frenliest communities in crypto, so don't hesitate to hop in!

Twikkle Discord: https://discord.gg/dAxGUfss


## Deployed Contract Addresses:
Twikkle were born on the Polygon sidechain. Below are the deployed Diamond addresses:


Twikkle Address (FlagContent contract and storage): 

Twikkle Address (VoteContent contract):  

TwiklToken Address: 0x74efcAe1D5659c25717B4A5924152E7358F1f5db


## Resources
Official docs: Coming soon!

Louper Dev Diamond Explorer: Coming soon!

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


