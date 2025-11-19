// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Repository is ERC721{
    string repoName;
    string repoFolderCID;
    address repoOwnerAddr;

    constructor(string memory _repoName, string memory _repoCID, address _creator) ERC721("RepositoryNFT", "REPO"){
        repoName = _repoName;
        repoFolderCID = _repoCID;
        repoOwnerAddr = _creator;
    }
}