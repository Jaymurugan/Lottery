// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interfaces} from "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol"; // We are importing this to integrate chainlink VRF.

/**
 *@title Raffle Smart Contract.
 *@author Jay Murugan
 *@notice This file consists of a contract that will be in charge of creating a raffle.
 *@dev Implement chainlink VRFv2 for randomness.
 */
contract Raffle {
    error Raffle__notEnoughEthSent(); // Custom error to reduce gas.

    uint16 private constant REQUEST_CONFIRMATION = 3;

    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee; // Let's make this immutable to save gas. We want this entrance fee to change depending on the contract. So we will create a constructor for it.

    uint256 private immutable i_interval; // We are creating a variable to hold a time which determines when the raffle gets called. We can change it in the constructor. It'll be in seconds.

    VRFCoordinatorV2Interfaces private immutable i_vrfCoordinator; // Variable to hold the coordinator address.

    bytes32 private immutable i_gasLane; // key hash is also going to be dependent on the chain. Hence we add it as immutable and to the constructor.

    uint64 private immutable i_subscriptionId;

    uint32 private immutable i_callbackGasLimit;

    uint256 private s_lastTimeStamp; // To keep track of what time the last winner was picked.

    address payable[] private s_players; // Place to store and track all the players. Since the size of the array changes, it is a storage variable. Since we need to pay the winner, we made it payable.
    // We didn't use mapping for this as we cannot loop through them.

    event EnteredRaffle(address indexed players); // We are creating an event. Whenever we call the enterRaffle fn, we are going to emit it.

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) {
        // This takes a new entrance fee and assign it to the immutable i_entranceFee.
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_gasLane = gasLane;
        i_vrfCoordinator = VRFCoordinatorV2Interfaces(vrfCoordinator);
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_lastTimeStamp = block.timestamp; // Our first time stamp should be set in the constructor.
    }

    function enterRaffle() external payable {
        // We want people to enter this raffle by buying a ticket. So we make it payable. We are making it external as we are not going have anything inside this contract call it. So it will be more gas efficient than public.
        // require(msg.value >= i_entranceFee, "Did not send enough eth"); // We could do like this but custom errors and revert are much more gas efficient than require.
        if (msg.value < i_entranceFee) {
            revert Raffle__notEnoughEthSent();
        }
        s_players.push(payable(msg.sender)); // We need this payable keyword to allow this sender address to receive native tokens.

        emit EnteredRaffle(msg.sender);
    }

    function pickWinner() external {
        // We want this fn to pick a random number, use that to pick a player, and have this fn automatically called.
        // We made it external so that we can make anybody call it as we did it done automatically. But we got to make sure that it gets called only when the lottery is ready to be picked. Hence we use time to determine that.
        // Current time - last time a winner was picked == interval, then we can pick a winner.
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            // black.timestamp is a global variable that gives us the current time. Here if enough time has not passed, we revert.
            revert();
        }
        // If we got past this if statement, then we can pick a winner. We will use chainlink VRF for it.
        // Getting a random number will be a 2 transaction fn: 1. Request the RNG. 2. Get the random number.
        uint256 requestId = i_vrfCoordinator.requestRandomWords( // look at the chainlink vrf subscription method get random documentation.
                i_gasLane,
                i_subscriptionId,
                REQUEST_CONFIRMATION, // How many confirmations do we want. Can we chain dependent but I'm gonna keep it as 3.
                i_callbackGasLimit, // Max gas the our callback function will do.
                NUM_WORDS // Number of random numbers that we want. We only want 1.
            );
    }

    function getEntranceFee() external view returns (uint256) {
        // We want people to know what the entrance fee is. So lets create a getter fn.
    }
}
