// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {Record} from "src/Record.sol";
import {MintRecord} from "script/Interactions.s.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract RecordTest is Test {
    Record record;
    MintRecord mintRecord;

    string public constant name = "Test Record";
    string public constant symbol = "TEST";
    uint256 public constant supply = 1000;
    uint256 public constant mintPrice = 0.01 ether;
    uint256 public constant newMintPrice = 0.02 ether;
    string public constant baseURI = "ipfs://QmdKR4KsvENPGBLzF9nrGLcDcFTexWwfBo7jjkPec5M3C8/";
    string public constant previewImageURI = "ipfs://QmZEyS8hagRvCL3dQuo232oECAzK1dWZvi5cxCGF9Dc8WF?=slap.PNG";

    address public user = makeAddr("user");
    address public owner = makeAddr("owner");
    uint256 public constant startingBalance = 1000 ether;

    // event emitted by ERC721A.sol during token transfer
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        record = new Record(name, symbol, baseURI, previewImageURI, supply, mintPrice, owner);

        vm.deal(user, startingBalance);
        vm.deal(owner, startingBalance);
    }

    function testDeployRevertsIfSupplyIsZero() public {
        vm.expectRevert(Record.SupplyMustBeGreaterThanZero.selector);
        new Record(name, symbol, baseURI, previewImageURI, 0, mintPrice, owner);
    }

    function testDeployRevertsIfMintPriceIsZero() public {
        vm.expectRevert(Record.MintPriceMustBeGreaterThanZero.selector);
        new Record(name, symbol, baseURI, previewImageURI, supply, 0, owner);
    }

    function testInitialState() public view {
        assertEq(record.supply(), supply);
        assertEq(record.mintPrice(), mintPrice);
        assertEq(record.tokenCount(), 0);
        assertEq(record.owner(), owner);
        assertEq(record.previewImageURI(), previewImageURI);
    }

    function testMintUpdatesTokenCountAndBalance() public {
        uint256 quantity = 1;
        vm.prank(user);
        record.mint{value: mintPrice}(quantity);

        assertEq(record.balanceOf(user), quantity);
    }

    function testMintMultipleUpdatesTokenCountAndBalance() public {
        uint256 quantity = 2;
        uint256 price = mintPrice * quantity;
        vm.prank(user);
        record.mint{value: price * quantity}(quantity);

        assertEq(record.balanceOf(user), quantity);
        assertEq(record.tokenCount(), quantity);
    }


    function testMintEmitsTransferEvent() public {
        // Expect Transfer event from the zero address to user for tokenId 0
        vm.prank(user);
        vm.expectEmit(true, true, true, true);
        emit Transfer(address(0), user, 0);
        record.mint{value: mintPrice}(1);
    }


    function testMintRevertsIfQuantityIsZero() public {
        vm.expectRevert(Record.MustMintMoreThanZero.selector);
        vm.prank(user);
        record.mint{value: 0}(0);
    }


    function testMintRevertsIfQuantityExceedsSupply() public {
        uint256 amountToMint = supply + 1;
        uint256 payment = mintPrice * amountToMint;
        vm.expectRevert(Record.CantMintMoreThanSupply.selector);
        vm.prank(user);
        record.mint{value: payment}(amountToMint);
    }
    

    function testMintFailsIfInsufficientFunds() public {
        uint256 payment = mintPrice - 1;
        vm.expectRevert(Record.InsufficientBalance.selector);
        vm.prank(user);
        record.mint{value: payment}(1);
    }

    function testTokenURI() public {
        string memory expectedURI = string(abi.encodePacked("ipfs://QmdKR4KsvENPGBLzF9nrGLcDcFTexWwfBo7jjkPec5M3C8/0.json"));
        vm.prank(user);
        record.mint{value: mintPrice}(1);

        string memory uri = record.tokenURI(0);
        assertEq(uri, expectedURI); 
    }

    function testRevertsWhenTokenDoesNotExist() public {
        vm.expectRevert(
            abi.encodeWithSelector(Record.TokenDoesNotExist.selector, 0)
        );
        record.tokenURI(0);
    }

    // all go to the contract now but addn royalties later
    function testOwnerCanWithdraw() public {
        uint256 initialBalance = address(owner).balance;
        
        uint256 mintAmount = 1;
        vm.prank(user);
        record.mint{value: mintPrice}(mintAmount);

        vm.prank(owner);
        record.withdraw();

        uint256 finalBalance = address(owner).balance;
        assertEq(finalBalance, initialBalance + mintPrice);
    }

    function testRevertsWhenNonOwnerWithdraws() public {
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user)
        );
        record.withdraw();
    }

    function testOwnerCanChangeMintPrice() public {
        vm.prank(owner);
        record.changeMintPrice(newMintPrice);
        
        assertEq(record.mintPrice(), newMintPrice);
    }

    function testRevertsWhenNonOwnerChangesMintPrice() public {
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, user)
        );
        record.changeMintPrice(newMintPrice);
    }

    function testRevertsWhenChangedMintPriceIsZero() public {
        vm.prank(owner);
        vm.expectRevert(Record.MintPriceMustBeGreaterThanZero.selector);
        record.changeMintPrice(0);
    }

    function testRevertsWhenChangingMintPriceAfterSoldOut() public {
        uint256 payment = mintPrice * supply;
        vm.prank(user);
        record.mint{value: payment}(supply);

        vm.expectRevert(Record.CannotChangePriceWhenSoldOut.selector);
        vm.prank(owner);
        record.changeMintPrice(newMintPrice);
    }

   function testCanGetTokensOfOwner(uint8 quantity1, uint8 quantity2, uint8 quantity3) public {

        // Clamp quantities to avoid overflow
        quantity1 = uint8(bound(quantity1, 1, 10));
        quantity2 = uint8(bound(quantity2, 1, 10));
        quantity3 = uint8(bound(quantity3, 1, 10));

        // Clamp total so it doesn't exceed supply
        uint256 totalMint = quantity1 + quantity2 + quantity3;
        require(totalMint <= supply, "Too many tokens");

        uint256 cost1 = uint256(quantity1) * mintPrice;


        vm.prank(user);
        record.mint{value: cost1}(quantity1);


        uint256[] memory userTokens = record.tokensOfOwner(user);

        for (uint256 i = 0; i < userTokens.length; i++) {
            console2.log("userTokens[%s] = %s", i, userTokens[i]);
        }


        assertEq(userTokens.length, quantity1);


        for (uint256 i = 0; i < userTokens.length; i++) {
            assertEq(record.ownerOf(userTokens[i]), user);
        }

    }

    


    
}

