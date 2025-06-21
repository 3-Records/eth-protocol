// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Record} from "src/Record.sol";

contract DeployRecord is Script {
    function run(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 maxSupply,
        uint256 mintPrice,
        address initialOwner
    ) external returns (Record) {
        vm.startBroadcast();
        Record record = new Record(
            name,
            symbol,
            baseURI,
            maxSupply,
            mintPrice,
            initialOwner
        );
        vm.stopBroadcast();
        return record;
    }
}
