//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
 
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';


contract NFT is Initializable, ERC1155Upgradeable, OwnableUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable, ERC1155BurnableUpgradeable, ERC1155SupplyUpgradeable, UUPSUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _tokenIds;
    address contractAddress;
    // PSA mapping to tokenId
    mapping(uint256 => string) private tokenURIs;
    // Titles mapping to tokens
    mapping(uint256 => string) private tokenTitles;


    struct PropertyToken {
        uint256 tokenId;
        string title;
        // string psas[];
    }
    // Optional mapping for token URIs
    // mapping(uint256 => string) private tokenURIs;

    function initialize(address marketplaceAddress) initializer public {
        __ERC1155_init("Mortar");
        __Ownable_init();
        __Pausable_init();
        __ERC1155Burnable_init();
        __ERC1155Supply_init();
        __UUPSUpgradeable_init();

        contractAddress = marketplaceAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // mints without data, then sets title string late
    function mint(string memory title) 
        public returns(uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        bytes memory bytesTitle = bytes(title);

        _mint(msg.sender, newItemId, 1, bytesTitle); // defaults to single NFT  
        tokenTitles[newItemId] = title; // store strinfied title object in map for easier access
        // give Market contract approval
        setApprovalForAll(contractAddress, true); 

        return newItemId;
    }

    // Fractionalize Property Ownership – convert NFT into many ERC-20s
    function fractionalize(string memory _tokenURI, uint256 _tokenId ) public returns(uint) {
        // require a _tokenURI and tokenId
         _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        uint256 sharesAmount = 10**7;

        // 1) burn NFT
        //require msg.sender to be owner of NFT
        _burn(msg.sender, _tokenId, 1);

        // 2) mint token with 10,000,000 shares
        _mint(msg.sender, newItemId, sharesAmount, ''); 
        tokenURIs[newItemId] = _tokenURI;

        // 3) add Mortar to Royalty Standard X% of each tx
        
        return newItemId;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // returns tokenURI
    function tokenURI (uint tokenId) public view returns (string memory)  {
        return tokenURIs[tokenId];
    }

    // returns bytes data
    function getTokenTitle(uint tokenId) public view returns (string memory)  {
        return tokenTitles[tokenId];
    }
}
