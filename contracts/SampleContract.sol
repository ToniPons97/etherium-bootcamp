//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract SampleContract {
    string public myString = "Hello world";
    address public owner;
    uint public updatesCount = 0;

    constructor() {
        owner = msg.sender;
    }

    function updateString(string memory newString) public {
        if (msg.sender == owner) {
            myString = newString;
            updatesCount++;
        }
    }
}