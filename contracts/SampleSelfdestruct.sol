//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

// DON'T USE THIS CRAP

contract StartStopUpdateExample {
    receive() external payable { }

    function destroySmartContract() public {
        selfdestruct(payable(msg.sender));
    }
}