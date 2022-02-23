//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
 
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol';
import '@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/access/AccessControlEnumerable.sol';


contract NFT is ERC1155, ERC1155Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    // Optional mapping for token URIs
    mapping(uint256 => string) private tokenURIs;

    /**
     * @dev Grants `DEFAULT_ADMIN_ROLE` and `PAUSER_ROLE` to the account that
     * deploys the contract.
     */
    constructor(address marketplaceAddress) ERC1155('Mortar') {
        contractAddress = marketplaceAddress;
    }

    /**
     * @dev Creates `amount` new tokens for `to`, of token type `id`.
     * Requirements:
     * - the caller must have the `MINTER_ROLE`.
     */
    function mintToken(string memory _tokenURI) public returns(uint)  {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        uint256 amount = 10**7;

        _mint(msg.sender, newItemId, amount, '');
        tokenURIs[newItemId] = _tokenURI;
        // give Market contract approval
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }

    // returns tokenURI
    function tokenURI (uint tokenId) public view returns (string memory)  {
        return tokenURIs[tokenId];
    }

    // burn by calling ERC1155Burnable
}
