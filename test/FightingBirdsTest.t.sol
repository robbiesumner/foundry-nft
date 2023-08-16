// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FightingBirds} from "../src/FightingBirds.sol";
import {DeployNFT} from "../script/DeployNFT.s.sol";

contract FightingBirdsTest is Test {
    FightingBirds fightingBirds;

    address USER = makeAddr("user");
    string constant DUCK =
        "ipfs://QmbUg27nokWcNtemR8ma7quPfk2dAMLaKngq1SkLM17Fgh/duck.json";

    function setUp() external {
        DeployNFT deployer = new DeployNFT();
        fightingBirds = deployer.run();
    }

    function testNameIsCorrect() external {
        string memory expectedName = "Fighting Birds";
        string memory actualName = fightingBirds.name();
        assertEq(actualName, expectedName);
    }

    function testSymbolIsCorrect() external {
        string memory expectedSymbol = "FBRD";
        string memory actualSymbol = fightingBirds.symbol();
        assertEq(actualSymbol, expectedSymbol);
    }

    function testCanMintAndHaveBalance() external {
        vm.prank(USER);
        fightingBirds.mint(DUCK);

        assertEq(fightingBirds.balanceOf(USER), 1);
        assertEq(DUCK, fightingBirds.tokenURI(0));
    }
}
