//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract BlockchainMessenger {
    address public owner;
    string public message = "Hello Etherium!!!";
    uint public numberOfUpdates = 0;

    constructor() {
        owner = msg.sender;
    }

    function setMessage(string memory _message) public {
        if (owner == msg.sender) {
            message = _message;
            numberOfUpdates++;
        }
    }
}