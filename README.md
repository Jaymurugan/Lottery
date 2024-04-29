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

## Chainlink VRF for randomness:

Use this documentation to learn more about how to integrate Chainlink VRF to generate a random number using the subscription method (We used subscription method as it is more scalable): https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number.

To import and integrate the modules properly, we need to download the chainlink smartcontractkit. We download chainlink-brownie-contracts as it is more minimal. To do that run this in the terminal: **forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit**. Add this to remappings in the foundary.toml since we pasted the import statement from the documentation, we need to remap it to brownie-contract.
