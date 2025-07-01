// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Record} from "src/Record.sol";
import {RecordFactory} from "src/RecordFactory.sol";
import { HelperConfig } from "script/HelperConfig.s.sol";
import {DevOpsTools} from "@foundry-devops/DevOpsTools.sol";

contract DeployRecord is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("RecordFactory", block.chainid);
        RecordFactory factory = RecordFactory(mostRecentlyDeployed);
        HelperConfig helperConfig = new HelperConfig();
        (
            address owner,
            string memory artist,
            string memory name,
            string memory symbol,
            string memory baseURI,
            uint256 supply,
            uint256 mintPrice
        ) = helperConfig.testConfig();
        HelperConfig.recordConfig memory testConfig = HelperConfig.recordConfig({
            owner: owner,
            artist: artist,
            name: name,
            symbol: symbol,
            baseURI: baseURI,
            supply: supply,
            mintPrice: mintPrice
        });

        deployRecordInFactory(
            factory,
            testConfig.owner,
            testConfig.artist,
            testConfig.name,
            testConfig.symbol,
            testConfig.baseURI,
            testConfig.supply,
            testConfig.mintPrice
        );
    }

    function deployRecordInFactory(
        RecordFactory factory,
        address owner,
        string memory artist,
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 supply,
        uint256 mintPrice
    ) internal {
        vm.startBroadcast();
        new Record(name, symbol, baseURI, supply, mintPrice, owner);
        factory.deployRecord(owner, artist, name, symbol, baseURI, supply, mintPrice);
        vm.stopBroadcast();
    }
}


contract MintRecord is Script {

    function run(address record, uint256 quantity) external payable {
        vm.startBroadcast();
        Record(record).mint{value: msg.value}(quantity);
        vm.stopBroadcast();
    }


}
