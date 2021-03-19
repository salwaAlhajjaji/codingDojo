//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 < 0.8.1;


/**
 * @title Tech Insurance tor
 * @dev complete the functions
 */
contract TechInsurance{
   address public contractOwner;
    uint M = 2;
    address [] public authenticators ;
    // address [] public v_Authenticators;
    mapping (uint => uint) public v_Authenticators;


    mapping (address => bool) public isAdmin;
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
    //////************
    uint time;
    //////************
    constructor(address payable _insOwner) public {
        insOwner = _insOwner;
        contractOwner = msg.sender;
        isAdmin[msg.sender] = false;
    }
    
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
     // //  // //ERC721 decleration
    mapping (address => uint256) private _balances;
    mapping (uint256 => address) private _owners;
    mapping (uint256 => address) private _tokenApprovals;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);




    
    uint public productCounter;
    
    address payable public insOwner ;
    
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public avilable (){
        Product memory newProduct = Product (_productId, _productName, _price, false);
        // productIndex[productCounter++] = newProduct;
        productIndex[_productId] = newProduct;
        //v_Authenticators[_productId] = 0;
        _mint(msg.sender, _productId);
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
    //   revert("do not run this function again it cost you some fees");
     }
 
     
    function changePrice(uint _productIndex, uint _price) public  onlyOwner{
        productIndex[_productIndex].price = _price;
    }

    function buyInsurance(uint _productIndex) public  payable {
        require(productIndex[_productIndex].offered == true, "Tha Insurance is not available");
        Client memory newClient = Client (true, block.timestamp);
        client[msg.sender][_productIndex] =   newClient ;
        require(msg.value  == productIndex[_productIndex].price, "check the amount of the Insurance");
        //////*****************
         time=  client[msg.sender][_productIndex].time;
         /////******************
        uint256 price = productIndex[_productIndex].price;
        // changeFalse( _productIndex);
        payable(msg.sender).transfer(price);
         _transfer(ownerOf(_productIndex), msg.sender, _productIndex);
    } 
    
    function transferInsurance( address to, uint256 _id) public {
       require(msg.sender != to," You are the owner of this Insurance ");
       require(ownerOf(_id) == msg.sender," Your not the Owner ");
        _transfer(msg.sender, to, _id);
    }
    
    ///////// refund funcation
    function refund (uint _productIndex) public  payable {
    uint p  = productIndex[_productIndex].price;
  if (block.timestamp >= time + 30 seconds) {
      changeTrue(_productIndex);
      payable(msg.sender).transfer(p);
     }
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
    //*///////////////////*****************Permission ///////////////////////
     modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Not contract owner");
        _;
    }
    
    modifier notNull(address _address) {
    require(_address != address(0));
        _;
    }
    
//available modifier will control adding product after number of signature(M) accomplish
modifier avilable () {
        require(getAuths().length >= M,"You are not allow");
        _;
    }
    
    
    modifier AuthenticatorExist(address _address) {
        require(isAdmin[_address] == false, "already added!");
        _;
  }

    // -- helper functions
    function getAuths() public view returns (address[] memory)
    {
        return authenticators;
    }
    //here will adding members and give them Authrization
    function addAuths(address _address) public onlyContractOwner() AuthenticatorExist(_address) notNull(_address) {
        isAdmin[_address] = true;
        Authrize(_address);
    }
    
    function Authrize(address _add) private  returns (uint _x) {
        require(isAdmin[msg.sender] == true, "no you can't");
        authenticators.push(_add);
        return (authenticators.length);
    }
//the product will be not offer until number of signed members verify the product
function verify(uint _id) public {
            require(isAdmin[msg.sender] == true,"You're not Authrize");
            productCounter =  v_Authenticators[_id];
            v_Authenticators[_id] = productCounter+1;
            if (v_Authenticators[_id] >=2){
                productIndex[_id].offered = true;
            }
            
    }

}