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

    function getAllReposByOwner() external view returns (
        string[] memory folderCIDs, 
        uint256[] memory tokens,
        string[] memory name) {
        uint256 count = balanceOf(msg.sender);
        folderCIDs = new string[](count);
        tokens = new uint256[](count);
        name = new string[](count);
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(msg.sender, i);
            folderCIDs[i] = repositories[tokenId].getRepoFolderCID();
            tokens[i] = tokenId;
            name[i] = repositories[tokenId].getRepoName();
        }
    }

    function processNewCommit(
        uint256 _tokenId, 
        string memory message, 
        string memory commitCID) public 
    {
        Repository repo = repositories[_tokenId];
        repo.addPendingCommit(message, payable (msg.sender), commitCID);
        emit processedCommit(_tokenId, repo.getRepoOwner(), msg.sender, repo.getRepoFolderCID());
    }

    function rejectCommit(
        uint256 _tokenId,
        uint256 commitIndex) public
    {
        Repository repo = repositories[_tokenId];
        address commiter = repo.rejectCommit(commitIndex, msg.sender);
        emit rejectedCommit(commiter, repo.getRepoOwner(), repo.getRepoFolderCID());
    }

    function getAllRepos() external view returns (string[] memory folderCIDs, uint256[] memory tokens, address[] memory owners, string[] memory names) {
        uint256 count = totalSupply();
        folderCIDs = new string[](count);
        tokens = new uint256[](count);
        owners = new address[](count);
        names = new string[](count);

        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = tokenByIndex(i);
            folderCIDs[i] = repositories[tokenId].getRepoFolderCID();
            tokens[i] = tokenId;
            owners[i] = ownerOf(tokenId);
            names[i] = repositories[tokenId].getRepoName();
        }
    }

    function retrieveCommits(uint256 _tokenId) public view returns(
        string[] memory messages,
        uint256[] memory timestamps,
        address[] memory committers,
        uint256[] memory status,
        string[] memory commitCIDs
        )
    {
        Repository repo = repositories[_tokenId];
        return repo.getCommits();
    }

    event CreatedSuccessfully(
        uint256 indexed tokenId,
        address indexed owner,
        string repoCID
    );

    event processedCommit(
        uint256 indexed tokenId,
        address indexed owner,
        address indexed committer,
        string repoCID
    );

    event rejectedCommit(
        address indexed committer,
        address indexed rejectedBy,
        string repoCID
    );
}