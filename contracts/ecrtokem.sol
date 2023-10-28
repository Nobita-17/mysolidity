// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

interface IERC20 {      //Standard that needs to be followed 
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ERC20 is IERC20 {
    string public name = "queen";
    string public symbol="qun";
    uint8 public decimals=0;
    address public founder;
    mapping (address=>uint) accbalance; //information of balance of each address
    mapping(address => mapping(address =>uint)) public allowed;  //information to store which adress has access to use
    uint public totalSupply;   // solidity will make getter function for this variable automatically


    constructor(){
    totalSupply=200;  //total supply of Token 
    founder=msg.sender;
    accbalance[founder]=totalSupply;   //initally fonder will have the total share / supply

}

 function balanceOf(address _owner) external view returns (uint256) {
    return accbalance[_owner];    //gives the balance of particlular account 
}



function transfer(address _to, uint256 _value) external returns (bool success){
    require(_value>0, "Amount should be greater than zero");
    require(accbalance[msg.sender]>=_value,"You have Insufficeint Balance in your Account");
    accbalance[msg.sender]-=_value;
    accbalance[_to]+=_value;
    emit Transfer(msg.sender, _to, _value);
    return true;
   
}

 function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
    return allowed[_owner][_spender];   //will check we have given permission to how many toekn to sender
}

 function approve(address _spender, uint256 _value) external returns (bool success){
     require(_value>0, "Amount should be greater than zero");
    require(accbalance[msg.sender]>=_value,"You have Insufficeint Balance in your Account");
    allowed[_spender][_spender]=_value;     //give permission 

    return true;
 }


function transferFrom(address _from, address _to, uint256 _value) external returns (bool success){
   require(allowed[_from][_to]>=_value, "Recipteint do not have authority");
   require(accbalance[_from]>=_value, "You have insufficent Balance");
   accbalance[_to]+=_value;
   accbalance[_from]-=_value;
   emit Transfer(_from, _to, _value);
   return true;
}

}




