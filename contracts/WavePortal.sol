// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    mapping(address => uint256) public accountAccessCounter;
    mapping(address => uint256) public accountWaveCounter;

    constructor() {
        console.log("Yo yo, I am a contract am I am smart");
    }

    function wave() public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
        accountWaveCounter[msg.sender] = totalWaves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getTotalWavesByAccount() public view returns (uint256) {
        console.log(
            "We have %d total waves for the account!",
            address(msg.sender)
        );
        return accountWaveCounter[address(msg.sender)];
    }
}
