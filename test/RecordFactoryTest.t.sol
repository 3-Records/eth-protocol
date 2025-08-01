// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {RecordFactory} from "src/RecordFactory.sol";
import {Record} from "src/Record.sol";

contract RecordFactoryTest is Test {
    RecordFactory factory;
    
    address owner = makeAddr("owner");
    address user = makeAddr("user");
    uint256 constant startingBalance = 1000 ether;

    string public constant name = "Test Record";
    string public constant artist =  "Timmy Keegan";
    string public constant symbol = "TEST";
    uint256 public constant supply = 1000;
    uint256 public constant mintPrice = 0.01 ether;
    string public constant baseURI = "ipfs://QmdKR4KsvENPGBLzF9nrGLcDcFTexWwfBo7jjkPec5M3C8/";
    string public constant previewImageURI = "ipfs://QmZEyS8hagRvCL3dQuo232oECAzK1dWZvi5cxCGF9Dc8WF?=slap.PNG";

    function setUp() public {
        factory = new RecordFactory();
        vm.deal(user, startingBalance);
    }

    function testDeployRecord() public {
        vm.expectEmit(false, false, false, true);
        emit RecordFactory.RecordDeployed(
            address(0), 
            name,
            artist,
            symbol
        );

        factory.deployRecord(
            owner,
            artist,
            name,
            symbol,
            baseURI,
            previewImageURI,
            supply,
            mintPrice
        );
    }

}
