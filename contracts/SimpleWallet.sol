//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SimpleWallet is ReentrancyGuard {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawAll() public nonReentrant {
        require(msg.sender == owner, "Only the owner can withdraw");

        payable(owner).transfer(getBalance());
    }

    function withdrawTo(address payable _toAddress) public nonReentrant {
        require(msg.sender == owner, "Only the owner can withdraw");

        _toAddress.transfer(getBalance());
    }

    receive() external payable {}
    fallback() external payable {}
}

