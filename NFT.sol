// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0 ; 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";


contract NFT is ERC721URIStorage{
    uint public TokenCount ; 

    constructor() ERC721("WolfNFT" , "WLF"){}

    function mint(string memory _tokenURI) external returns(uint){

        TokenCount++ ; 
        _safeMint(msg.sender , TokenCount) ; 
        _setTokenURI(TokenCount ,  _tokenURI);
        return(TokenCount);

    }
}

