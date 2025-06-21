// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

//import "./AlbumTemplate.sol";

// Basic template, but finish the AlbumTemplate contract first
// also will need a way to resell the albums/records


// contract AlbumFactory {
//     mapping(string => address) public albums;

//     event AlbumDeployed(address indexed album, string name, string symbol);

//     function createAlbum(
//         string memory name,
//         string memory symbol,
//         string memory baseTokenURI,
//         uint256 initialMint
//     ) external {
//         AlbumTemplate album = new AlbumTemplate(
//             name,
//             symbol,
//             baseTokenURI,
//             msg.sender,
//             initialMint
//         );
//         albums.push(address(album));
//         emit AlbumDeployed(address(album), name, symbol);
//     }

//     function getAlbums() external view returns (address[] memory) {
//         return albums;
//     }
// }