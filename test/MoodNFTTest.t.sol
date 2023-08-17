// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {DeployMoodNFT} from "../script/DeployMoodNFT.s.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFTTest is Test {
    DeployMoodNFT deployer;
    MoodNFT moodNFT;

    string HAPPY_URI;
    string SAD_URI;
    string constant BASE_URI = "data:application/json;base64,";

    address USER = makeAddr("user");

    function setUp() external {
        deployer = new DeployMoodNFT();
        moodNFT = deployer.run();

        HAPPY_URI = string(
            abi.encodePacked(
                BASE_URI,
                Base64.encode(
                    abi.encodePacked(
                        '{"name": "Mood NFT", "description": "This reflects the owners current mood.", "attributes": [{"trait_type": "mood", "value": "happy"}], "image": "',
                        deployer.svgToImageURI(vm.readFile("./img/happy.svg")),
                        '"}'
                    )
                )
            )
        );

        SAD_URI = string(
            abi.encodePacked(
                BASE_URI,
                Base64.encode(
                    abi.encodePacked(
                        '{"name": "Mood NFT", "description": "This reflects the owners current mood.", "attributes": [{"trait_type": "mood", "value": "sad"}], "image": "',
                        deployer.svgToImageURI(vm.readFile("./img/sad.svg")),
                        '"}'
                    )
                )
            )
        );
    }

    function testViewTokenURI() external {
        vm.prank(USER);
        moodNFT.mint();
        console.log(moodNFT.tokenURI(0));
    }

    function testFlipMood() external {
        vm.prank(USER);
        moodNFT.mint();
        assertEq(moodNFT.tokenURI(0), HAPPY_URI);

        vm.prank(USER);
        moodNFT.flipMood(0);
        assertEq(moodNFT.tokenURI(0), SAD_URI);
    }
}
