// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../libraries/AppStorage.sol";

contract FlagContentFacet  {

    AppStorage internal s;

    // The function to flag content.
    function FlagContent(uint256 _contentID) public {

    // Check if the user has the correct permissions to flag content(merkle tree).
    //code

    // Create a new flaggedContent struct and store it in the mapping.

    s.flaggedContent memory newFlaggedContent;

    newFlaggedContent.contentID = _contentID;

    newFlaggedContent.flaggedTimestamp = block.timestamp;

    newFlaggedContent.flaggedBy = msg.sender;

    s.flaggedContents[_contentID] = newFlaggedContent;

    s._totalFlaggedContent ++;
  }
    
}