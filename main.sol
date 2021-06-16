pragma solidity ^0.4.0;

contract bank {
    uint balance;
    address owner;
    
    mapping(address => uint) private balances;
    
    function bank(){
        owner = msg.sender;
        balances[owner] = 100;
    }
    
    function withDraw (uint withdrawAmount) returns (uint amount){
        if(owner == msg.sender ){
            if(amount >= balances[owner]){
                    return 0;
            }
            balances[owner] -= withdrawAmount;
            return balances[owner];
        }
    }
    
    function deposit(uint depositeAmount) returns (uint totamount){
        balances[owner] += depositeAmount;
        return balances[owner]; 
    }
    
    function transfer(address address_to , address address_from , uint amountTransfer) returns (bool){
        // uint temp = 0;
        if (balances[address_from] >= amountTransfer && amountTransfer > 0){
            balances[address_from] = balances[address_from] - amountTransfer;
             
            balances[address_to] += amountTransfer; // Transfer amount added to address_to
            return true;
        }
        return false;
       
    }
    
    function getBalance(address address_user) constant  returns (uint) {
        return balances[address_user];
    }
    
}
