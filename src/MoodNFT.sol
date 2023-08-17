// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    using Counters for Counters.Counter;
    enum Mood {
        HAPPY,
        SAD
    }

    error MoodNFT__NotOwnerOfToken();

    Counters.Counter private tokenIdCounter;
    string private s_happySvgImageURI;
    string private s_sadSvgImageURI;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory happySvgImageURI,
        string memory sadSvgImageURI
    ) ERC721("Mood NFT", "MOOD") {
        s_happySvgImageURI = happySvgImageURI;
        s_sadSvgImageURI = sadSvgImageURI;
    }

    function mint() external {
        uint256 tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        s_tokenIdToMood[tokenId] = Mood.HAPPY;
        _safeMint(msg.sender, tokenId);
    }

    function flipMood(uint256 tokenId) external {
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNFT__NotOwnerOfToken();
        }
        s_tokenIdToMood[tokenId] = s_tokenIdToMood[tokenId] == Mood.HAPPY
            ? Mood.SAD
            : Mood.HAPPY;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        Mood mood = s_tokenIdToMood[tokenId];
        string memory moodString;
        string memory imageURI;

        if (mood == Mood.HAPPY) {
            moodString = "happy";
            imageURI = s_happySvgImageURI;
        } else if (mood == Mood.SAD) {
            moodString = "sad";
            imageURI = s_sadSvgImageURI;
        }

        bytes memory tokenMetaData = abi.encodePacked(
            '{"name": "',
            name(),
            '", "description": "This reflects the owners current mood.", "attributes": [{"trait_type": "mood", "value": "',
            moodString,
            '"}], "image": "',
            imageURI,
            '"}'
        );
        string memory tokenMetaDataBase64 = Base64.encode(tokenMetaData);

        return string(abi.encodePacked(_baseURI(), tokenMetaDataBase64));
    }
}
