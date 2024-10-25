//SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

contract ExampleExceptionRequire {
    mapping(address => uint8) public balances;

    function deposit() public payable {
        assert(msg.value == uint8(msg.value));
        balances[msg.sender] += uint8(msg.value);
    }

    function withdrawl(address payable _to, uint8 _amount) public {
        require(balances[msg.sender] >= _amount, "Amount has to be less than or equal to your current balance.");
        balances[msg.sender] -= _amount;

        _to.transfer(_amount);
    } 
}