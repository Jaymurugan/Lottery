# Lottery Smart Contract With Solidity

## Overview:

This is a random smart contract lottery.

## What is does:

    * Users can purchase a ticket to participate in the raffle.
    * After the agreed upon time, the lottery will draw a winner and this will be done by the code.
    * Chainlink VRF and Chainlink Automation will be used.
            VRF for randomness. // Creating a randomness in blockchain is extremely difficult. Hence we are using chainlink to generate a randomness outside of the blockchain.
            Automation for trigger based on time.

## Initialization:

First to create our new project we do: forge init. If the directory that we are creating the new project is non empty try: **forge init --force**.

Create a new file called raffle.sol in the src folder. This file is going to be responsible for a raffle and we will use chainlink VRF for the randomness.

Use **forge build** to see if the project is compiling successfully.
