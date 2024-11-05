//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract MyContract {
    uint public myUint = 123;

    function setMyUint(uint _value) public {
        myUint = _value;
    }
}