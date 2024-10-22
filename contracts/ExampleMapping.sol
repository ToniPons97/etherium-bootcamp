//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract ExampleMapping {
    mapping(uint => bool) public myMapping;
    mapping(address => bool) public myAddressMapping;
    mapping(uint => mapping(uint => bool)) public uintUintBoolMapping;

    function setValue(uint _index) public {
        myMapping[_index] = true;
    }

    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;
    }

    function setUintUintValue(uint _i, uint _j, bool _value) public {
        uintUintBoolMapping[_i][_j] = _value;
    } 
}