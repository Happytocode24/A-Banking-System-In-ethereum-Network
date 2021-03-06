pragma solidity 0.6.0;



contract Bank {
    uint internal fund = 100;                           // liquid fund of bank
    uint internal AuM;                                  // bank's assets under management
    uint internal lend;                                 // amount lend
    int public interestRate;                            // interest rate per year
    address public owner;                               // trusted owner of the contract
    mapping (address => int) internal balance;          // LUT of balances
    mapping (address => uint) internal lastTransaction; // LUT of last transaction for interest calculation
    
    constructor() public { 
        owner = msg.sender;
    }

    
    function getBalance() public view returns(int) {                    // return the balance of the current account
        return balance[msg.sender];
    }
    
    function deposit() external payable {                               // deposit money in the current account
        uint amount = msg.value;
        interest(amount);                                               // add interest to account
        balance[msg.sender] += int(amount);                             // increase account balance
        AuM += amount;                                                  // increase assets under bank's management
    }

    function withdraw(uint amount) external {                           // withdraw money from the current account if funds are sufficient
        interest(amount);                                               // add interest to account
        require(int(amount)<=balance[msg.sender], "Balance is not sufficient"); 
        balance[msg.sender] -= int(amount);                             // decrease account balance
        AuM -= amount;                                                  // decrease assets under bank's management
        msg.sender.transfer(amount);
    }
    
    function interest(uint amount) internal {                                   // calculate interest from last transaction to now, assuming monthly interest
        uint months = (now-lastTransaction[msg.sender])/60/60/24/30;            // number of full months since last account interaction
        int Interest = int(amount)*(1+interestRate/12)**(months) - int(amount); // compound interest gained
        balance[msg.sender] += Interest;                                        // add interest to account 
        fund -= uint(Interest);                                                 // subtract interest from bank's funds
        lastTransaction[msg.sender] = now;
    }
    
    function internalTransfer(address destination, uint amount) external {  // send money to another account within bank
        interest(amount);                                                   // add interest to account
        require(int(amount)<=balance[msg.sender], "Balance is not sufficient"); 
        balance[msg.sender] -= int(amount);
        balance[destination] += int(amount);
    }
    
    
}

//TODO: Create instances of banks with class inheritance
