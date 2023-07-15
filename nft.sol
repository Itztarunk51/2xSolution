// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WhitelistNFT is ERC721, Ownable {
    mapping(address => bool) public whitelist;
    uint256 public tokenCounter;
    bool public whitelistEnabled;

    constructor() ERC721("WhitelistNFT", "WNFT") {
        tokenCounter = 0;
        whitelistEnabled = true;
    }

    function addToWhitelist(address _address) public onlyOwner {
        whitelist[_address] = true;
    }

    function removeFromWhitelist(address _address) public onlyOwner {
        whitelist[_address] = false;
    }

    function toggleWhitelist() public onlyOwner {
        whitelistEnabled = !whitelistEnabled;
    }

    function mintNFT() public {
        require(!whitelistEnabled || whitelist[msg.sender], "Not on whitelist");
        _safeMint(msg.sender, tokenCounter);
        tokenCounter++;
    }
}
