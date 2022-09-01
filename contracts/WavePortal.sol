// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // generate a random number
    uint256 private seed;

    // callback to track if a new wave has occured
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct PeopleAttributes {
        address walletId;
        uint256 waveCount;
    }

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // Array of wave structs
    Wave[] waves;

    // A mapping from an address => number of waves
    mapping(address => uint256) public peopleWaveCounts;
    mapping(uint256 => PeopleAttributes) public userAttributes;
    
    // Mapping to store waves
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");
        // Set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 
         * 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 10 seconds < block.timestamp,
            "Wait 10 Seconds"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastWavedAt[msg.sender] = block.timestamp;

        // Increment the current number of waves 
        totalWaves += 1;
        console.log("%s waved w/ message %s", msg.sender, _message);

        // store the wave in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        
        //Give a 50% chance that the user wins the prize.
        if (seed < 50) {
            console.log("%s won!", msg.sender);

            // The same code we had before to send the prize.
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        // Emit an event to say you have a new wave
        emit NewWave(msg.sender, block.timestamp, _message);

        // My code
        peopleWaveCounts[msg.sender] += 1;

        userAttributes[totalWaves] = PeopleAttributes({
            walletId: msg.sender,
            waveCount: peopleWaveCounts[msg.sender]
        });


    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getPeopleWaveCounts(address _user) public view returns (uint256){
        console.log("%s has %s wave counts.", _user, peopleWaveCounts[_user]);
        return peopleWaveCounts[_user];
    }

    function getUserAttributes(uint _userId) public view {
        PeopleAttributes memory user = userAttributes[_userId];
        console.log("User wave count is: %s", user.waveCount);
    }

    // gets all the waves and returns array of Waves
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}