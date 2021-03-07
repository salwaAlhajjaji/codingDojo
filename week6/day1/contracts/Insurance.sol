//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 < 0.8.1;

contract TechInsurance{
    struct Product {
        uint productId;
        string productName;
        uint price;
        bool offered;
    }
     
    struct Client {
        bool isValid;
        uint time;
    }
    // constructor(address payable _insOwner) public {
    //     insOwner = _insOwner;
    // }
    constructor() {
        insOwner = msg.sender;
    }
    
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
     // //  // //ERC721 decleration
    mapping (address => uint256) private _balances;
    mapping (uint256 => address) private _owners;
    mapping (uint256 => address) private _tokenApprovals;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    // //  // //ERC721 decleration End
    
    uint productCounter;
    address payable public insOwner ;
    
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public  {
        Product memory newProduct = Product (_productId, _productName, _price, true);
        productIndex[productCounter++] = newProduct;
        _mint(msg.sender, productCounter);

    }
      function fatch(uint _productId) public view returns(string memory name, uint price, bool offered ){
        name = productIndex[_productId].productName; 
        price = productIndex[_productId].price; 
        offered = productIndex[_productId].offered; 

   
    }

    
    function changeFalse(uint _productIndex) public  onlyOwner {
        productIndex[_productIndex].offered = false;
    }
    
    function changeTrue(uint _productIndex) public  onlyOwner{
        productIndex[_productIndex].offered = true;
    }
    
    modifier onlyOwner {
      require(msg.sender == insOwner, "you are not the owner" );
      _;
      revert("do not run this function again it cost you some fees");
     }
 
     
    function changePrice(uint _productIndex, uint _price) public  onlyOwner{
        productIndex[_productIndex].price = _price;
    }

    function buyInsurance(uint _productIndex) public  payable {
        require(productIndex[_productIndex].offered == true, "Tha Insurance is not available");
        Client memory newClient = Client (true, block.timestamp);
        client[msg.sender][_productIndex] =   newClient ;
        require(msg.value  == productIndex[_productIndex].price, "check the amount of the Insurance");
        
        uint256 price = productIndex[_productIndex].price;
        payable(msg.sender).transfer(price);
    } 
    
    function transferInsurance( address to, uint256 _id) public {
       require(msg.sender != to," You are the owner of this Insurance ");
       require(ownerOf(_id) == msg.sender," Your not the Owner ");
        _transfer(msg.sender, to, _id);
    }
    //  // //ERC721 functions
    
     function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
}

  function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

 function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
 
  function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    
     function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
     function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

}