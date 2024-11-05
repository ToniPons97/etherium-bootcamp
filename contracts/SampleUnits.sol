//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract SampleUnits {
    modifier betweenOneAndTwo() {
        // This could also be written as 1e18 (1 x 10¹⁸)...
        require(msg.value >= 1 ether && msg.value <= 2 ether, "Value must be between 1 and 2 eth");
        _;
    }

    uint runUntilTimestamp;
    uint startTimestamp;

    constructor(uint startInDays) {
                                           // (startInDays * 24 * 60 * 60);
        startTimestamp = block.timestamp + (startInDays * 1 days);
        runUntilTimestamp = startTimestamp + 7 days;
    }

    /*
        Available time units

        seconds
        minutes
        hours
        days
        weeks
    */
}