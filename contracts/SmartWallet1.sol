//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Consumer {
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {}

    receive() external payable { }
}

contract SmartWallet1 {
    address public owner;
    mapping(address => User) public users;
    uint public numOfGuardians;
    uint public maxGuardians = 5;
    uint public minRequiredGuardians = 3;
    uint public initialAllowanceAmount = 2 ether;

    struct User {
        uint balance;
        uint allowance;
        bool isGuardian;
    }

    constructor() payable {
        owner = msg.sender;
        users[owner].balance = msg.value;
        users[owner].isGuardian = true;
        users[owner].allowance = initialAllowanceAmount;
        numOfGuardians++;
    }

    function setGuardian(address _user, bool _value) public {
        require(msg.sender == owner, "Only the owner can add new guardians.");
        require(numOfGuardians < maxGuardians, "All guardians have been assigned.");
        require(_user != address(0), "Address must be non-empty.");
        require(users[_user].isGuardian == false, "This user already is a guardian.");

        users[_user].isGuardian = _value;

        if (_value) {
            numOfGuardians++;
        } else if (numOfGuardians > 0) {
            numOfGuardians--;
        }
    }

    function increaseMaxGuardians(uint _numOfGuardians) public {
        require(msg.sender == owner, "Only the owner can modify maxGuardians.");
        require(_numOfGuardians > maxGuardians, "New number of max guardians must be higher than current number of max guardians.");
        maxGuardians = _numOfGuardians;
    }

    function setNewOwner(address[] memory _guardians, address _newOwner) public {
        require(_newOwner != address(0), "New owner address must be non-empty.");
        require(_newOwner != owner, "New owner already is the current owner.");
        require(_guardians.length > 0, "_guardians length is 0 or less.");
        require(_guardians.length <= maxGuardians, "_guardians length must be less or equal to maxGuardians.");

        uint validGuardians = 0;
        
        for (uint i = 0; i < _guardians.length; i++) {
            address candidate = _guardians[i];
            
            require(!isDuplicateGuardian(_guardians, candidate), "Duplicate address found.");
            
            if (users[candidate].isGuardian) {
                validGuardians++;
            }
        }

        require(validGuardians >= minRequiredGuardians, "Not enough guardians to perform this action.");
        
        users[owner].isGuardian = false;
        users[_newOwner].isGuardian = true;
        owner = _newOwner;
    }


    function setAllowance(address _user, uint _amount) public {
        require(_user != address(0), "_user must be a valid address.");
        require(msg.sender == owner, "Only the owner can update allowance.");
        require(_amount > 0, "Allowance should be a positive number.");

        users[_user].allowance = _amount;
    }

    function getBalance(address _user) public view returns(uint) {
        return users[_user].balance;
    }

    function getAllowance(address _user) public view returns(uint) {
        return users[_user].allowance;
    }
    
    function deposit(address payable _to) public payable {
        require(msg.value > 0, "Amount should be a positive number");
        users[_to].balance += msg.value;
    }

    function withdrawTo(address payable _to, uint _amount) public {
        require(getBalance(msg.sender) - _amount >= 0, "Not enough balance.");
        require(_amount <= getAllowance(msg.sender), "Amount exceedes current allowance. Increase it or reduce amount.");
        
        users[msg.sender].balance -= _amount;
        users[msg.sender].allowance -= _amount;
        _to.transfer(_amount);
    }

    function sendMoney(address _contract, uint _amount, bytes memory _payload) public {
        // address should be valid
        require(_contract != address(0), "Address should be non-empty.");
        // amount must be less or equal to user balance
        require(getBalance(msg.sender) >= _amount, "Not enough balance.");
        // amount must be less or equal to allowance
        require(_amount <= users[msg.sender].allowance, "Not enough allowance. Talk to the owner.");

        (bool success, ) = _contract.call{value: _amount, gas: 1000000}(_payload);
        require(success, "Contract call was unsuccessful.");

        users[msg.sender].balance -= _amount;
        users[msg.sender].allowance -= _amount;
    }

    function isDuplicateGuardian(address[] memory _guardians, address _candidate) private pure returns(bool) {
        for (uint i = 0; i < _guardians.length; i++) {
            if (_guardians[i] == _candidate) {
                return true;
            }
        }

        return false;
    }

    receive() external payable { 
        deposit(payable(msg.sender));
    }
}