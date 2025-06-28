// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Record} from "src/Record.sol";
import {DevOpsTools} from "@foundry-devops/DevOpsTools.sol";

contract MintRecord is Script {

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("Record", block.chainid);
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        Record(contractAddress).mint(1);
        vm.stopBroadcast();
    }

    function mintMultipleNFTsOnContract(address contractAddress, uint256 quantity) public {
        vm.startBroadcast();
        Record(contractAddress).mint(quantity);
        vm.stopBroadcast();
    }
}
