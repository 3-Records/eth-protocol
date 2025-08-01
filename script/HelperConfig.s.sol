// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;



contract HelperConfig {

    struct recordConfig {
        address owner;
        string artist;
        string name;
        string symbol;
        string baseURI;
        string previewImageURI;
        uint256 supply;
        uint256 mintPrice;
    }

    recordConfig public testConfig;

    constructor() {
        testConfig = recordConfig({
            owner: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            artist: "Timmy Keegan",
            name: "Test Record",
            symbol: "TEST",
            baseURI: "ipfs://QmdKR4KsvENPGBLzF9nrGLcDcFTexWwfBo7jjkPec5M3C8/",
            previewImageURI: "ipfs://QmZEyS8hagRvCL3dQuo232oECAzK1dWZvi5cxCGF9Dc8WF?=slap.PNG",
            supply: 1000,
            mintPrice: 0.01 ether
        });
    }
}