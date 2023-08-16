// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FightingBirds} from "../src/FightingBirds.sol";

contract DeployNFT is Script {
    function run() external returns (FightingBirds fightingBirds) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        fightingBirds = new FightingBirds();
        vm.stopBroadcast();
    }
}
