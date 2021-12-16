// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";

contract PlatziPunks is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    uint256 public maxSupply;

    Counters.Counter private _tokenIdCounter;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLPKS") {
        maxSupply = _maxSupply;
    }

    function mint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= maxSupply, "No PLatzi Punks left =(");
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override  returns(string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "PlatziPunks #',
                tokenId, //TODO
                '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "image": "',
                "//TODO: Calculate imager URL",
                '"}'
            )
        );
        
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // The following functions are overrides required by inherited Contracts

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);

    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        super.supportsInterface(interfaceId);
    }
}