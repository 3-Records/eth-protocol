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


contract Record is ERC721A, Ownable {
    error SupplyMustBeGreaterThanZero();
    error MintPriceMustBeGreaterThanZero();
    error MustMintMoreThanZero();
    error CantMintMoreThanSupply();
    error InsufficientBalance();
    error TokenDoesNotExist();
    error CannotChangePriceWhenSoldOut();
    
    
    uint256 private s_supply;
    uint256 private s_mintPrice;
    string private s_baseURI;

    event RecordSoldOut();

    

    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI,
        uint256 _supply,
        uint256 _mintPrice,
        address owner
    ) ERC721A(name, symbol) Ownable(owner) {
        if(_supply <= 0) {
            revert SupplyMustBeGreaterThanZero();
        }
        if(_mintPrice <= 0) {
            revert MintPriceMustBeGreaterThanZero();
        }
        s_supply = _supply;
        s_mintPrice = _mintPrice;
        s_baseURI = baseURI;
    }

    // -------- Public Mint -------- //
    function mint(uint256 quantity) external payable {
        if (quantity <= 0) {
            revert MustMintMoreThanZero();
        }
        if (quantity + _nextTokenId() > s_supply) {
            revert CantMintMoreThanSupply();
        }
        if (msg.value < s_mintPrice * quantity) {
            revert InsufficientBalance();
        }

        _mint(msg.sender, quantity);
    
        if (_nextTokenId() == s_supply) {
            emit RecordSoldOut();
        }
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function changeMintPrice(uint256 newMintPrice) external onlyOwner {
        if (_nextTokenId() == s_supply) {
            revert CannotChangePriceWhenSoldOut();
        }
        if (newMintPrice <= 0) {
            revert MintPriceMustBeGreaterThanZero();
        }
        // emit price chnage?
        s_mintPrice = newMintPrice;
    }

    function _baseURI() internal view override returns (string memory) {
        return s_baseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_exists(tokenId)) {
            revert TokenDoesNotExist();
        }
        return string(abi.encodePacked(_baseURI(), _toString(tokenId), ".json"));
    }
    
    function supply() external view returns (uint256) {
        return s_supply;
    }

    function mintPrice() external view returns (uint256) {
        return s_mintPrice;
    }

    function tokenCount() external view returns (uint256) {
        return _nextTokenId();
    }

   
}
