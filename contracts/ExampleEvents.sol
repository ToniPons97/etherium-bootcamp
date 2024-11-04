//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract EventExample {
    // By typing _to as an indexed field, it can be used to filter events by that parameter. It becomes a topic.
    // The first topic is the event name, then we have 3 extra topics that we can configure.
    event TokensSent(address indexed _from, address indexed _to, uint _amount);
    
    mapping(address => uint) public tokenBalance;

    constructor() {
        tokenBalance[msg.sender] = 100;
    }

    function sendTokens(address _to, uint _amount) public returns(bool) {
        require(tokenBalance[msg.sender] >= _amount, "You don't have enough funds");
        tokenBalance[msg.sender] -= _amount;
        tokenBalance[_to] += _amount;

        emit TokensSent(msg.sender, _to, _amount);
        return true;
    }
}