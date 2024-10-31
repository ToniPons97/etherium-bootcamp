//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Consumer {
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {}

    receive() external payable { }
}

contract SmartWallet2 {
    address payable owner;

    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;
    mapping(address => bool) public guardians;

    address payable nextOwner;
    uint guardiansResetCount;
    uint public constant confirmationFromGuardiansForReset = 3;

    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;

    constructor() {
        owner = payable(msg.sender);
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "Only guardians can perform this action.");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted.");

        if (_newOwner != nextOwner) {
            nextOwner = _newOwner;
            guardiansResetCount =  0;
        }

        guardiansResetCount++;

        if (guardiansResetCount >= confirmationFromGuardiansForReset) {
            owner = nextOwner;
            nextOwner = payable(address(0));
        }

    }

    function setGuardian(address _for, bool _value) public {
        require(msg.sender == owner, "Only the owner is authorized to perform this action.");
        require(_for != address(0), "Address must be valid.");

        guardians[_for] = _value;
    }

    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "Only the owner is authorized to perform this action.");
        require(_for != address(0), "Address must be valid.");

        allowance[_for] = _amount;
        isAllowedToSend[_for] = _amount > 0;
    }

    function transfer(address payable  _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        if(msg.sender != owner) {
            require(allowance[msg.sender] >= _amount, "You are trying to send more than allowed.");
            require(isAllowedToSend[msg.sender], "You are not allowed to send.");

            allowance[msg.sender] -= _amount;
        }


        (bool success, bytes memory returnData) = _to.call{value: _amount, gas: 100000}(_payload);
        require(success, "Transaction was unsuccessful.");

        return returnData;
    }

    receive() external payable { }
}