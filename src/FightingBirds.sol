// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/* Imports */
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

contract FightingBirds is ERC721 {
    /* Type declarations */
    using Counters for Counters.Counter;

    /* State variables */
    Counters.Counter private s_tokenIdCounter;
    mapping(uint256 => string) private s_tokenIdToTokenURI;

    /* Events */
    /* Errors */
    /* Modifiers */

    /* Functions */
    /* Constructor */
    constructor() ERC721("Fighting Birds", "FBRD") {}

    /* Receive function */
    /* Fallback function */
    /* External functions */
    function mint(string memory _tokenURI) external {
        uint256 tokenId = s_tokenIdCounter.current();
        s_tokenIdCounter.increment();
        s_tokenIdToTokenURI[tokenId] = _tokenURI;
        _safeMint(msg.sender, tokenId);
    }

    /* Public functions */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToTokenURI[tokenId];
    }
    /* Internal functions */
    /* Private functions */
}
