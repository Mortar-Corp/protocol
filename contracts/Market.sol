//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import '@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol';
import 'hardhat/console.sol';

contract Market is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable, PausableUpgradeable, ERC1155HolderUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter private _itemIds;
    CountersUpgradeable.Counter private _tokensSold;
    CountersUpgradeable.Counter private _tokensForSale;
    address payable _owner; 
    uint256 mortarFee;

    function initialize() public initializer {
        _owner = payable(msg.sender);
    }

    struct MarketToken {
        uint256 itemId; // market id
        address nftContract;
        uint256 tokenId; // nft id
        address payable seller;
        address payable owner; 
        uint256 amount;
        uint256 price;
        bool sold;
    }

    // tokenId return which MarketToken -  fetch which one it is 
    mapping(uint256 => MarketToken) private idToMarketToken;

    // listen to events
    event MarketTokenMinted (
        uint256 indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 amount,
        uint256 price,
        bool sold
    );

    // get the listing price
    function getMortarFee() public view returns (uint256) {
        return mortarFee;
    }

    // Put item up for sale – NFT 
    function createMarketItem(
        address nftContract,
        uint256 tokenId
    ) public payable nonReentrant { 
         _itemIds.increment();
        uint256 newItemId = _itemIds.current();
        uint256 amount = 1;
        uint256 price = 0; // default (non-listed) price set to 0

        idToMarketToken[newItemId] = MarketToken(
            newItemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(msg.sender), // set owner to lister
            amount,
            price,
            false
        );

        emit MarketTokenMinted(
            newItemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            amount,
            price,
            false
        );
    }

    // list for sale (update price and change ownership to market contract)
    function listMarketItemForSale(
        address nftContract,
        uint256 itemId,
        uint256 price
    ) nonReentrant() public payable { 
        require(price > 0, 'Price must be at least one wei');
        uint256 tokenId = idToMarketToken[itemId].tokenId;
        uint256 amount = idToMarketToken[itemId].amount;

        // putting it up for sale, update marketToken and set market contract as owner
        idToMarketToken[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)), 
            amount,
            price,
            false
        );

        // NFT transaction – transfer ownership to marketplace
        ERC1155Upgradeable(nftContract).safeTransferFrom(msg.sender, address(this), tokenId, amount, '');

        _tokensForSale.increment();
    }

    // Put item up for sale – ERC-20s 
    function createMarketFractionalItem(
        address nftContract,
        uint256 itemId, // index of NFT MarketItem
        uint256 tokenId,
        uint256 amount
    ) public payable nonReentrant { 
        _itemIds.increment();
        uint256 newItemId = _itemIds.current();
        uint256 price = 0;

        // remove NFT (set amount to 0) – keep other data same for record keeping
        idToMarketToken[itemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            0,
            price,
            false
        );

        // add a new Market Token for fractional item
        idToMarketToken[newItemId] = MarketToken(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            amount,
            price,
            false
        );

        // NFT transaction – transfer ownership to marketplace
        ERC1155Upgradeable(nftContract).safeTransferFrom(msg.sender, address(this), tokenId, amount, '');

        emit MarketTokenMinted(
            newItemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            amount,
            price,
            false
        );
    }

    // transact shares between addresses
    function createMarketSale(
        address nftContract,
        uint256 itemId,
        uint256 amount
    ) public payable nonReentrant {
        uint price = idToMarketToken[itemId].price;
        uint tokenId = idToMarketToken[itemId].tokenId;
        require(msg.value == price, 'Please submit the asking price in order to continue');
        require(amount <= idToMarketToken[itemId].tokenId, 'Amount is greater than number of shares outstanding');

        // transfer purchase price to the seller
        idToMarketToken[itemId].seller.transfer(msg.value);

        // transfer Token(s)
        if (amount > 1000) { // fractionlized properties
            uint256 mortarShare = mortarFee * amount;
            uint buyerShare = amount - mortarShare;
            // transfer mortar share to mortar
            _owner.transfer(mortarShare);
            ERC1155Upgradeable(nftContract).safeTransferFrom(address(this),msg.sender, tokenId, buyerShare, '');
        } else {
            ERC1155Upgradeable(nftContract).safeTransferFrom(address(this),msg.sender, tokenId, amount, '');
        }

        idToMarketToken[itemId].owner = payable(msg.sender); // buyer address
        idToMarketToken[itemId].sold = true;
        _tokensSold.increment(); 
    }

    // returns all unsold market items 
    function fetchMarketTokens() public view returns(MarketToken[] memory) {
        uint256 itemCount = _itemIds.current();
        uint256 forSaleItemCount = _tokensForSale.current();
        uint256 currentIndex = 0;

        // looping over the number of items created (if number has not been sold populate the array)
        MarketToken[] memory items = new MarketToken[](forSaleItemCount);
        if (forSaleItemCount > 0) {
            // go through all market items
            for (uint256 i = 0; i < itemCount; i++) {
                if (idToMarketToken[i + 1].owner == address(0)) {
                    MarketToken storage currentItem = idToMarketToken[i + 1];
                    items[currentIndex] = currentItem; 
                    currentIndex += 1;
                }
            } 
        }
        return items; 
    }

    // return nfts that the user has purchased
    function fetchMyNFTs() public view returns (MarketToken[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        // get total number of my items
        for (uint256 i = 0; i < totalItemCount; i++) {
            // if token address = activeUser
            if (idToMarketToken[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        // check to see if the owner address is equal to msg.sender
        MarketToken[] memory items = new MarketToken[](itemCount);
        for (uint256 i = 0; i < totalItemCount; i++) {
            // if token address = activeUser
            if (idToMarketToken[i +1].owner == msg.sender) {
                uint256 currentId = idToMarketToken[i + 1].itemId;
                MarketToken storage currentItem = idToMarketToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // return nft by id
    function fetchNFT(uint256 tokenId) public view returns (MarketToken[] memory) {
        uint totalItemCount = _itemIds.current();
        uint currentIndex = 0;

        // return one token
        MarketToken[] memory item = new MarketToken[](1);
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketToken[i + 1].tokenId == tokenId) {
                uint currentId = i + 1;
                MarketToken storage currentItem = idToMarketToken[currentId];
                item[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return item;
    }

    // function for returning an array of minted nfts – same as fetchMyNFTs but checking .seller instead of .owner
    function fetchItemsCreated() public view returns(MarketToken[] memory) {
        uint256 totalItemCount = _itemIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for(uint256 i = 0; i < totalItemCount; i++) {
            if(idToMarketToken[i + 1].seller == msg.sender) {
                itemCount += 1;
            }
        }

        // check to see if the owner address is equal to msg.sender
        MarketToken[] memory items = new MarketToken[](itemCount);
        for(uint256 i = 0; i < totalItemCount; i++) {
            if(idToMarketToken[i +1].seller == msg.sender) {
                uint256 currentId = idToMarketToken[i + 1].itemId;
                MarketToken storage currentItem = idToMarketToken[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }
}
