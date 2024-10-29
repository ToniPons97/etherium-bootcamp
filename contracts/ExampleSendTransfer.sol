//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

contract Sender {
    fallback() external payable { }

    function withdrawTransfer(address payable _to) public {
        _to.transfer(10);
    }

    function withdrawSend(address payable _to) public {
        // Send is a low level interaction, so you have to take care of error handling.
        bool isSent = _to.send(10);

        require(isSent, "Sending the funds was unsuccessful.");
    }
}

contract ReceiverNoAction {
    receive() external payable { }
    
    function balance() public view returns(uint) {
        return address(this).balance;
    }
}

contract ReceiverAction {
    uint public balanceReceived;

    receive() external payable {
        balanceReceived += msg.value;
    }

    function balance() public view returns(uint) {
        return address(this).balance;
    }
}