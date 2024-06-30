# Welcome To Twikkl Smart Contracts!

Twikkle smart contracts consist of User-content Flaging and Restriction smart contracts. The contracts implement the EIP-2535 Diamonds standard, which allows for modular upgradeability.

Twikkle is a decentralized video sharing app with social services and more.

We also have one of the frenliest communities in crypto, so don't hesitate to hop in!

Twikkle Discord: https://discord.gg/dAxGUfss


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

## Verify diamond contract on etherscan

### Hardhat

```bash
$ npx hardhat verify --network netwokName diamond_contract_address contract_owner_address diamondcut_facet_address
```

## Verify contract on etherscan

### Hardhat

```bash
$ npx hardhat verify --network netwokName contract_address
```

### Foundry

```bash
$ forge t
```


## Deployed Contract Addresses:

Twikkle smart contract was deployed on the Sepolia blockchain. Below are the deployed Diamond addresses:

// ZKSYNC TESTNET

TwikklNFT was deployed to 0x3267ea8b87988cB53F43F790F54FA302DEe23395<br>
TwikklToken was deployed to 0x5B932aeb47f5a02881cD31ff44157E6902Ec6cE4<br>
VoteContent Contract was deployed to 0xc6d5FC4d0d055812b072e5527Cd3caA6D2F5F67C<br>

// Zora
ZoraNft was deployed to 0x27Bf0f8ecAB278e4EDAE5eE193D37Db511F624D9<br>
Zora SingleEditionMintableCreator contract is 0x4500590AfC7f12575d613457aF01F06b1eEE57a3<br>
For more info: [check here](https://github.com/ourzora/nft-editions) or [here](https://docs.zora.co/contracts/intro)


// ZKSYNC MAINNET

TwikklNFT was deployed to 
0x5B932aeb47f5a02881cD31ff44157E6902Ec6cE4<br>
TwikklToken was deployed to 
0x3267ea8b87988cB53F43F790F54FA302DEe23395<br>
VoteContent Contract was deployed to 
0xc6d5FC4d0d055812b072e5527Cd3caA6D2F5F67C<br>

// SEPOLIA TESTNET
TwikklToken deployed to Sepolia: 0x50886AB774220706744394F351ee468952eC6112

TwikklNFT deployed to:

// Sepolia Testnet Contract Address

DiamondCutFacet deployed: 0xcB1b2130E0069384C187c2D11325B91D1da608Ae

Diamond deployed: 0x6b9C0b9287bF15a88492A9f3D9C48E538fE7Ca37

DiamondInit deployed: 0x6d62169396b00e4a59350689db105aeF8fd05605

DiamondLoupeFacet deployed: 0xaF2c01DA73FD81ea010f167B71668941cD6A9782

OwnershipFacet deployed: 0xd3BE7B5c2246de2Ee62fbBb171212818BE15B9b2

VoteContentFacet deployed: 0xF555c624CC0B78A84dbf94777B965414BCdeE581


// Mumbai Testnet Contract Address

DiamondCutFacet deployed: 0xcB1b2130E0069384C187c2D11325B91D1da608Ae<br>

Diamond deployed: 0x6b9C0b9287bF15a88492A9f3D9C48E538fE7Ca37<br>

DiamondInit deployed: 0x6d62169396b00e4a59350689db105aeF8fd05605<br>

DiamondLoupeFacet deployed: 0xaF2c01DA73FD81ea010f167B71668941cD6A9782<br>

OwnershipFacet deployed: 0xd3BE7B5c2246de2Ee62fbBb171212818BE15B9b2<br>

VoteContentFacet deployed: 0xF555c624CC0B78A84dbf94777B965414BCdeE581<br>


// Georli Testnet Contract Address

DiamondCutFacet deployed: 0xF555c624CC0B78A84dbf94777B965414BCdeE581

Diamond deployed: 0x1C80420A98C72b4D697fB659C9BBF15fe39EBb4F

DiamondInit deployed: 0x9Be59BEd24E6D75dFBb0a194096DbE0e797Ea49c

DiamondLoupeFacet deployed: 0x5149f0F28572E1a7cE8Cfe8a7dCb79356064f6C0

OwnershipFacet deployed: 0xC3c1d8061d4B0f1399F4baA5F058b544eA6CAb26

VoteContentFacet deployed: 0xAFc5d8C7Fb1a254dd9AF68b1cDAd34a12E6ac6eB


## Resources
Official docs: Coming soon!

Louper Dev Diamond Explorer: https://louper.dev/diamond/COMING_SOON?network=sepolia

Official Subgraph: Coming soon!

EIP2535 Primer: https://eips.ethereum.org/EIPS/eip-2535

`Note`: A lot of improvements are still needed so contributions are welcome!!

Bonus: The [DiamondLoupefacet](contracts/facets/DiamondLoupeFacet.sol) uses an updated [LibDiamond](contracts/libraries//LibDiamond.sol) which utilises solidity custom errors to make debugging easier especially when upgrading diamonds. Take it for a spin!!


