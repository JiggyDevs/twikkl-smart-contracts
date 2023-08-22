// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {AppStorage, flaggedContent} from "../libraries/AppStorage.sol";

/**
 * @title FlagContentFacet
 * @dev A smart contract for flagging content and storing flagged content details.
 */

contract FlagContentFacet {
    AppStorage internal s;

    mapping(uint256 => flaggedContent) flaggedContents;

    /**
     * @notice Get details of a flagged content by content ID.
     * @param contentID The ID of the content to retrieve details for.
     * @return The details of the flagged content.
     */
    function getFlaggedContent(
        uint256 contentID
    ) public view returns (flaggedContent memory) {
        return s.flaggedContents[contentID];
    }

    /**
     * @notice Flag a content by its ID.
     * @param _contentID The ID of the content to be flagged.
     */
    function FlagContent(uint256 _contentID) public {
        require(_contentID != 0, "Flag valid content!");

        require(msg.sender != address(0), "No permission to flag content");

        // Create a new flaggedContent struct and store it in the mapping.

        flaggedContent memory newFlaggedContent = flaggedContent({
            contentID: _contentID,
            flaggedTimestamp: block.timestamp,
            flaggedBy: msg.sender
        });

        s.flaggedContents[_contentID] = newFlaggedContent;

        s._totalFlaggedContent++;
    }
}
