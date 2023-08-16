// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FightingBirds} from "../src/FightingBirds.sol";

contract MintBird is Script {
    string constant DUCK =
        "ipfs://QmbUg27nokWcNtemR8ma7quPfk2dAMLaKngq1SkLM17Fgh/duck.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FightingBirds",
            block.chainid
        );
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) internal {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        FightingBirds(contractAddress).mint(DUCK);
        vm.stopBroadcast();
    }
}
