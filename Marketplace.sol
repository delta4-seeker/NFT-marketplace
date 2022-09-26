// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0 ; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";



contract NFTMarketplace is  ReentrancyGuard {

    address payable public  immutable fee_address ; 
    uint public immutable fee_percent ; 
    uint public itemCount ; 

    struct Item{
        uint item_id ; 
        ERC721 nft ; 
        address payable seller ; 
        uint token_id ; 
        bool sold ; 
        uint price  ; 
    }

    constructor(uint _fee_percent)  {
        fee_address = payable(msg.sender);

        fee_percent = _fee_percent ; 

    }

    event offered(
        uint item_id , 
        address indexed nft , 
        address seller , 
        uint indexed token_id , 
        uint price 
    );

    event bought(
        uint item_id , 
        address indexed nft , 
        uint indexed token_id ,
        address buyer , 
        address seller , 
        uint price 

    );
        


    mapping(uint => Item) items ; 

    function CreateItem( ERC721 _nft , uint _token_id ,  uint _price ) external  nonReentrant  {

        require( _price > 0 , "Price cannot be zero") ; 
        itemCount++ ; 
        _nft.transferFrom(msg.sender , address(this), _token_id);

        items[itemCount] = Item(
            itemCount ,
            _nft ,
            payable(msg.sender) ,
            _token_id , 
            false  , 
            _price
        );

        emit offered(
            items[itemCount].item_id , 
            address(items[itemCount].nft) ,
            items[itemCount].seller , 
            items[itemCount].token_id , 
            items[itemCount].price 

        );

    }




    function purchase(uint _item_id)  public payable nonReentrant{
            require(_item_id > 0 && _item_id <= itemCount , "Item doesnot exist.");

            Item  memory selected_item = items[_item_id] ; 

            uint total_fee = get_total_fee(selected_item.price);
            selected_item.nft.transferFrom(address(this) , msg.sender , selected_item.token_id);
            selected_item.sold ; 
            selected_item.seller.transfer(selected_item.price) ; 
            fee_address.transfer(total_fee - selected_item.price);

            emit bought(
                _item_id , 
                address(selected_item.nft) , 
                selected_item.token_id ,
                msg.sender , 
                selected_item.seller , 
                selected_item.price 
            );


    }

    function get_total_fee(uint price) private view returns(uint) {

        return( price*(100 + fee_percent)/100);

    }
}

