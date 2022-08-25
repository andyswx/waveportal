// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    struct PeopleAttributes {
        address walletId;
        uint256 waveCount;
    }

    // A mapping from an address => number of waves
    mapping(address => uint256) public peopleWaveCounts;
    mapping(uint256 => PeopleAttributes) public userAttributes;
    


    constructor() {
        console.log("TX9000 Online");
    }

    function wave() public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
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
}