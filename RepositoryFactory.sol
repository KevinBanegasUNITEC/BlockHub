// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./Repository.sol";

contract RepositoryFactory is ERC721Enumerable {

    constructor() ERC721("RepositoryFactory", "REPO") {}

    mapping (uint256 => Repository) private repositories;

    function createRepository(string memory _repoName, string memory _repoCID) public {
        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);

        repositories[tokenId] = new Repository(_repoName, _repoCID, msg.sender);
        
        emit CreatedSuccessfully(tokenId, msg.sender, _repoCID);
    }

    event CreatedSuccessfully(
        uint256 indexed tokenId,
        address indexed owner,
        string repoCID
    );
}