// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract MyContract {
    string public ourString = "Hello world";

    function updateString(string memory _updateString) public {
        ourString = _updateString;
    }
}