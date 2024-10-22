//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract ExampleWrapAround {
    uint256 public myUint;
    uint8 public myUint8 = 2**4;

    function setMyUint(uint256 _myUint) public {
        myUint = _myUint;
    }

    function incrementMyUint8() public {
        myUint8++;
    }

    function decrementMyUint8() public {
        unchecked {
            myUint8--;
        }
    }
}