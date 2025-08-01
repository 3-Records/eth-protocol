// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { Record } from "src/Record.sol";
import { RecordFactory } from "src/RecordFactory.sol";

contract DeployRecordFactory is Script {
    function run() external returns (RecordFactory) {
        vm.startBroadcast();
        RecordFactory factory = new RecordFactory();
        vm.stopBroadcast();
        return factory;
    }
}
