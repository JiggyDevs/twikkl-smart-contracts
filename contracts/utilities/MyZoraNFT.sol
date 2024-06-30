// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@zoralabs/nft-editions-contracts/contracts/SingleEditionMintableCreator.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyZoraNFT is OwnableUpgradeable {
    SingleEditionMintableCreator public editionsContract;

    function initialize(address editionsAddress) public initializer {
        __Ownable_init();
        editionsContract = SingleEditionMintableCreator(editionsAddress);
    }

    function createEditionWithReferral(
        string memory name,
        string memory symbol,
        string memory description,
        string memory animationUrl,
        bytes32 animationHash,
        string memory imageUrl,
        bytes32 imageHash,
        uint256 editionSize,
        uint256 royaltyBPS
    ) external onlyOwner {
        editionsContract.createEdition(
            name,
            symbol,
            description,
            animationUrl,
            animationHash,
            imageUrl,
            imageHash,
            editionSize,
            royaltyBPS
        );
    }

    function checkNFT(uint256 tokenId) external payable {
        // editionsContract.mintEdition{value: msg.value}(tokenId, msg.sender);
        editionsContract.getEditionAtId(tokenId);
    }
}
