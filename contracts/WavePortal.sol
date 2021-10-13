// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;
    /*
     * A little magic, Google what events are in Solidity!
     */
    event NewWave(
        address indexed from,
        uint256 timestamp,
        string message,
        bool isLucky
    );

    /*
     * I created a struct here named Wave.
     * A struct is basically a custom datatype where we can customize what we want to hold inside it.
     */
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
        bool isLucky;
    }
    /*
     * I declare a variable waves that lets me store an array of structs.
     * This is what lets me hold all the waves anyone ever sends to me!
     */
    Wave[] waves;
    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    mapping(address => uint256) public accountAccessCounter;
    mapping(address => uint256) public accountWaveCounter;
    event Waved(address user);

    constructor() payable {
        console.log("Eu sou um contrato very smarty!");
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        /*
         * Generate a Psuedo random number between 0 and 100
         */
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) %
            100;
        console.log("Random # generated: %s", randomNumber);
        /*
         * Set the generated, random number as the seed for the next wave
         */
        seed = randomNumber;
        bool isLucky = randomNumber < 50;
        waves.push(Wave(msg.sender, _message, block.timestamp, isLucky));
        console.log("com sorte: %s", isLucky);
        if (isLucky) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message, isLucky);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
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
