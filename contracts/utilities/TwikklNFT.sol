// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TwikklNFT
 * @dev A smart contract implementing the ERC721 Non-Fungible Token Standard with URI storage.
 */

contract TwikklNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
     * @dev Constructor to initialize the ERC721 token.
     */
    constructor() ERC721("JiggyNFT", "JGYNFT") {}

    /**
     * @notice Mint a new NFT and assign it to the recipient address.
     * @param recipient The address to which the newly minted NFT will be assigned.
     * @param tokenURI The metadata URI for the NFT.
     * @return The ID of the newly minted NFT.
     */
    function mintNFT(address recipient, string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}