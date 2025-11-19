// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./Repository.sol";

contract RepositoryFactory is ERC721Enumerable {

    constructor() ERC721("RepositoryFactory", "REPO") {}

    mapping (uint256 => Repository) private repositories;
}