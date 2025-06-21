// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

import {ERC721A} from "@ERC721A/contracts/ERC721A.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error MustMintMoreThanZero();
error CantMintMoreThanMaxSupply();
error InsufficientBalance();
error TokenDoesNotExist();
error CantDecreaseMaxSupply();

contract Record is ERC721A, Ownable {
    uint256 private s_maxSupply;
    uint256 private s_mintPrice;
    uint256 private s_tokenCount;

    // maybe shouldbe immutable
    string private s_baseURI;

    // mapping(uint256 => string) private s_tokenIdToURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI_,
        uint256 initialMaxSupply,
        uint256 initialMintPrice,
        address initialOwner
    ) ERC721A(name, symbol) Ownable(initialOwner) {
        s_baseURI = baseURI_;
        s_maxSupply = initialMaxSupply;
        s_mintPrice = initialMintPrice;
        s_tokenCount = 0;
    }

    // -------- Public Mint -------- //
    function mint(uint256 quantity) external payable {
        if (quantity <= 0) {
            revert MustMintMoreThanZero();
        }
        if (quantity + totalSupply() > s_maxSupply) {
            revert CantMintMoreThanMaxSupply();
        }
        if (msg.value < s_mintPrice * quantity) {
            revert InsufficientBalance();
        }

        // uint256 startId = _nextTokenId();
        _mint(msg.sender, quantity);

        // for (uint256 i = 0; i < quantity; i++) {
        //     s_tokenIdToURI[startId + i] = i_baseURI;
        // }

        s_tokenCount += quantity;
    }

    // // -------- Admin Mint -------- //
    // function ownerMint(uint256 quantity, string[] calldata uris) external onlyOwner {
    //     require(quantity > 0, "Must mint at least 1");
    //     require(quantity == uris.length, "Quantity and URIs length mismatch");
    //     require(totalSupply() + quantity <= s_maxSupply, "Exceeds max supply");

    //     uint256 startId = _nextTokenId();
    //     _mint(msg.sender, quantity);

    //     for (uint256 i = 0; i < quantity; i++) {
    //         s_tokenIdToURI[startId + i] = uris[i];
    //     }

    //     s_tokenCounter += quantity;

    function increaseSupply(uint256 newMaxSupply) external onlyOwner {
        if (newMaxSupply <= s_maxSupply) {
            revert CantDecreaseMaxSupply();
        }
        s_maxSupply = newMaxSupply;
    }

    // -------- Read Functions (Getters) -------- //
    function maxSupply() external view returns (uint256) {
        return s_maxSupply;
    }

    function mintPrice() external view returns (uint256) {
        return s_mintPrice;
    }

    function baseURI() external view returns (string memory) {
        return s_baseURI;
    }

    function tokenCount() external view returns (uint256) {
        return s_tokenCount;
    }

    // function tokenURI(uint256 tokenId) public view override returns (string memory) {
    //     if (!_exists(tokenId)) {
    //         revert TokenDoesNotExist();
    //     }
    //     return s_tokenIdToURI[tokenId];
    // }

    // -------- Withdraw -------- //
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
