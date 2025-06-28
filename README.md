## Music NFT 

- Try on and off chain
    - IPFS
    - On chain will probably be very gas expensive but look into it



Look into sound.xyz



Could focus more on concert recordings 
each nft/recoring could have a differnt picture of the event


eip 2981 for royalties


Id want different images or atrwork from the event to be randomly assigned to each token and maybe a digital signature that are different. Make each unique so some can be more desired than others.


end goal would to be able to use usdc instead of native token like eth, but eth is definetly easier

---



Right now i have my test recoprd hacve a direct ipfs link to the music 

Need a way to encrypt the ipfs file and can only decrypt if youre the owner of the NFT.


```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract NFTContentAccess {

    address public owner;
    address public nftContract;
    string public ipfsEncryptedCID; // Points to encrypted content

    // Optional: mapping of token ID -> specific content (multi-token gating)
    mapping(uint256 => string) public tokenToCID;

    event AccessRequested(address indexed requester, uint256 indexed tokenId);
    event CIDUpdated(string newCID);

    constructor(address _nftContract, string memory _initialCID) {
        owner = msg.sender;
        nftContract = _nftContract;
        ipfsEncryptedCID = _initialCID;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /// Set encrypted content URI
    function updateCID(string calldata _newCID) external onlyOwner {
        ipfsEncryptedCID = _newCID;
        emit CIDUpdated(_newCID);
    }

    /// Returns true if caller owns the NFT
    function canAccess(uint256 tokenId) public view returns (bool) {
        return IERC721(nftContract).ownerOf(tokenId) == msg.sender;
    }

    /// Frontend/off-chain service listens to this
    function requestAccess(uint256 tokenId) external {
        require(canAccess(tokenId), "You don't own this token");
        emit AccessRequested(msg.sender, tokenId);
        // Off-chain service listens and re-encrypts/sends AES key
    }

    /// Optional: token-specific CID support
    function setTokenCID(uint256 tokenId, string calldata _cid) external onlyOwner {
        tokenToCID[tokenId] = _cid;
    }

    function getTokenCID(uint256 tokenId) external view returns (string memory) {
        require(canAccess(tokenId), "Not authorized");
        return tokenToCID[tokenId];
    }
}
```
