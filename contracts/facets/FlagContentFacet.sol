// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {AppStorage, flaggedContent} from "../libraries/AppStorage.sol";

contract FlagContentFacet {
    AppStorage internal s;

    mapping(uint256 => flaggedContent) flaggedContents;

    function getFlaggedContent(
        uint256 contentID
    ) public view returns (flaggedContent memory) {
        return s.flaggedContents[contentID];
    }

    // The function to flag content.
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
