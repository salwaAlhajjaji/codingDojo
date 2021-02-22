pragma solidity >=0.7.0 <0.8.0;


contract MappingCity {
    

    mapping(string => string )  cityCountry;
    
      function setNames (string memory _cityName, string memory _contryName) public{
        cityCountry[_cityName] = _contryName;
        
    }
    
    function getCountry (string memory _cityName) public view returns(string memory){
        return cityCountry[_cityName];
            
    }
    function removeCity(string memory _cityName) public {
        delete(cityCountry[_cityName]);
    }
    
}
