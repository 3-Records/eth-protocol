// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Record} from  "src/Record.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract RecordFactory is Ownable {
    event RecordDeployed(address indexed album, string name, string artist, string symbol);
    
    constructor() Ownable(msg.sender) {}


    function deployRecord (
        address owner,
        string memory artist,
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 supply,
        uint256 mintPrice
    ) external onlyOwner {
        Record record = new Record(
            name,
            symbol,
            baseURI,
            supply,
            mintPrice,
            owner
        );
        emit RecordDeployed(address(record), name, artist, symbol);
    }


}
