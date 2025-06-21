// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Record} from "src/Record.sol";
import {DeployRecord} from "script/DeployRecord.s.sol";
import {MintRecord} from "script/Interactions.s.sol";

contract RecordTest is Test {
    DeployRecord deployer;
    Record record;
    MintRecord mintRecord;

    address public user = makeAddr("user");
    address public owner = makeAddr("owner");

    string public constant name = "Test";
    string public constant symbol = "TEST";
    uint256 public constant maxSupply = 1000;
    uint256 public constant mintPrice = 0.01 ether;

    uint256 public constant startingBalance = 1 ether;
    uint256 public constant quantity1 = 1;
    uint256 public constant quantity5 = 5;

    string public constant recordURI =
        "ipfs://QmRNL5ztx3PHW6LdKwrYN3txxwHT4rSTMYndxt17GafMBc?filename=testrecord.json";

    // event emitted by ERC721.sol during token transfer
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        deployer = new DeployRecord();
        record = deployer.run(
            name,
            symbol,
            recordURI,
            maxSupply,
            mintPrice,
            owner
        );

        vm.deal(user, startingBalance);
    }

    function testNameIsCorrect() public view {
        bytes32 expectedNameHash = keccak256(abi.encodePacked("Test"));
        bytes32 actualNameHash = keccak256(abi.encodePacked(record.name()));
        assert(expectedNameHash == actualNameHash);
    }

    function testSymbolIsCorrect() public view {
        bytes32 expectedSymbolHash = keccak256(abi.encodePacked("TEST"));
        bytes32 actualSymbolHash = keccak256(abi.encodePacked(record.symbol()));
        assert(expectedSymbolHash == actualSymbolHash);
    }
    

    function testMintdHasBalance() public {
        vm.prank(user);
        record.mint{value: mintPrice}(quantity1);
        assert(record.balanceOf(user) == 1);
    }

    // Update stiff with URI as i have to have a system with different URIs for each token
    function testMintHasCorrectBaseURI() public  {
        vm.prank(user);
        record.mint{value: mintPrice}(quantity1);
        assertEq(record.baseURI(), recordURI);
    }

    function testMintEmitsTransferEvent() public {
        // Expect Transfer event: from the zero address to USER for tokenId 0
        vm.prank(user);
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), user, 0);
        record.mint{value: mintPrice}(quantity1);
    }

    // // Test that minting multiple NFTs increments token IDs and balances
    // function testMintingMultipleTokensIncrementsTokenIdAndHasTheCorrectBalance() public {
    //     vm.prank(USER);
    //     basicNFT.mintNFT(cuteStar);
    //     vm.prank(USER);
    //     basicNFT.mintNFT(cuteStar);

    //     assertEq(basicNFT.balanceOf(USER), 2);
    //     assertEq(keccak256(abi.encodePacked(basicNFT.tokenURI(1))), keccak256(abi.encodePacked(cuteStar)));
    // }

//     function testTokenURIRevertsForNonExistentTokenDuringTransfer() public {
//         address scott = makeAddr("scott");

//         // no token has been minted yet
//         vm.expectRevert();
//         vm.prank(USER);
//         basicNFT.transferFrom(USER, scott, 0);
//     }

//     function testTransferNFT() public {
//         address scott = makeAddr("scott");

//         vm.prank(USER);
//         basicNFT.mintNFT(cuteStar);
//         uint256 tokenId = 0;

//         vm.prank(USER);
//         basicNFT.transferFrom(USER, scott, tokenId);

//         assertEq(basicNFT.balanceOf(USER), 0);
//         assertEq(basicNFT.balanceOf(scott), 1);
//         assertEq(keccak256(abi.encodePacked(basicNFT.tokenURI(tokenId))), keccak256(abi.encodePacked(cuteStar)));
//     }

//     function testMintEmitsTransferEvent() public {
//         // Expect Transfer event: from the zero address to USER for tokenId 0
//         vm.prank(USER);
//         vm.expectEmit(true, true, true, true);
//         emit Transfer(address(0), USER, 0);
//         basicNFT.mintNFT(cuteStar);
//     }
}



