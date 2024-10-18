//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract ExamplePayable {
    string public message = "Hello world";
    address owner;

    constructor() {
        owner = msg.sender;
    }


    function updateMessage(string memory _message) public payable {
        if (msg.value == 1 ether) {
            message = _message;
        } else {
            payable(msg.sender).transfer(msg.value);
        }
    }

    function getAccountBalance() public view returns(uint) {
        return owner.balance;
    }

    function getContractBalance() public view returns(uint) {
        return address(this).balance;
    }
}