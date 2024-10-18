# Closes Guess Game Contract

This repository contains a smart contract written in Cairo for a two-player guessing game on the StarkNet blockchain. Players take turns guessing a secret number, and the player with the closest guess wins.

## Overview

In this game, the contract owner sets a secret number. Two players can make guesses, and after both have guessed, the contract determines which guess is closest to the secret number. 

## Features

- *Set Secret Number*: The contract owner can set a secret number that players will try to guess.
- *Player Guesses*: Each player can submit their guess, and the contract keeps track of the number of attempts made by each player.
- *Determine Winner*: After both players have guessed, the contract determines which guess is closest to the secret number and declares the winner.

## Contract Functions

### IGuessTheNumber Trait

- *set_secret_number(number: u32)*: Sets the secret number for the game.
- *guess(player_id: u8, guess_number: u32) -> (u8, u32)*: 
  - Accepts a player's guess and returns feedback:
    - 0: Correct guess
    - 1: Guess is lower than the secret number
    - 2: Guess is higher than the secret number
  - Returns the number of attempts made by the guessing player.
- *get_attempts() -> (u32, u32)*: Returns the number of attempts made by both players.
- *declare_winner() -> u8*: Determines and returns the winner:
  - 0: Player 1 wins
  - 1: Player 2 wins
  - 2: Tie
  
 ![WhatsApp Image 2024-10-18 at 20 59 45_532577d6](https://github.com/user-attachments/assets/9cfc6cf6-1509-4acd-aa66-bfc603174e4d)



## How to Use

1. *Deploy the Contract*: Use the StarkNet CLI or your preferred tool to deploy the contract to the StarkNet blockchain.
2. *Set the Secret Number*: The contract owner calls the set_secret_number function to set the secret number.
3. *Players Make Guesses*: Players take turns calling the guess function with their guesses.
4. *Determine the Winner*: After both players have guessed, call the declare_winner function to determine the winner.

## Example Usage

```cairo
// Set the secret number
contract.set_secret_number(42);

// Player 1 guesses
let feedback1 = contract.guess(1, 40);

// Player 2 guesses
let feedback2 = contract.guess(2, 45);

// Determine the winner
let winner = contract.declare_winner();
