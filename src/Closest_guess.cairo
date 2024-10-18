#[starknet::interface]
trait IGuessTheNumber<TContractState> {
    fn set_secret_number(ref self: TContractState, number: u32);
    fn guess(ref self: TContractState, player_id: u8, guess_number: u32) -> (u8, u32); // (feedback, attempts)
    fn get_attempts(ref self: TContractState) -> (u32, u32); // Get the number of attempts for both players
    fn declare_winner(ref self: TContractState) -> u8; // Return the winner (0 for Player 1, 1 for Player 2, 2 for tie)
}

#[starknet::contract]
mod GuessTheNumber {
    #[storage]
    struct Storage {
        secret_number: u32,
        attempts_player1: u32,
        attempts_player2: u32,
        guess_player1: u32,
        guess_player2: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // Initialize attempts to zero
        self.attempts_player1.write(0);
        self.attempts_player2.write(0);
        self.guess_player1.write(0);
        self.guess_player2.write(0);
    }

    #[abi(embed_v0)]
    impl GuessTheNumber of super::IGuessTheNumber<ContractState> {
        fn set_secret_number(ref self: ContractState, number: u32) {
            // Set the secret number
            self.secret_number.write(number);
        }

        fn guess(ref self: ContractState, player_id: u8, guess_number: u32) -> (u8, u32) {
            // Store guesses and increment attempts count
            if player_id == 1 {
                let attempts = self.attempts_player1.read() + 1;
                self.attempts_player1.write(attempts);
                self.guess_player1.write(guess_number);
            } else if player_id == 2 {
                let attempts = self.attempts_player2.read() + 1;
                self.attempts_player2.write(attempts);
                self.guess_player2.write(guess_number);
            }

            // Get the secret number
            let secret_number = self.secret_number.read();

            // Provide feedback
            if player_id == 1 {
                if guess_number < secret_number {
                    return (1, self.attempts_player1.read()); // 1 means "higher"
                } else if guess_number > secret_number {
                    return (2, self.attempts_player1.read()); // 2 means "lower"
                } else {
                    return (0, self.attempts_player1.read()); // 0 means "correct"
                }
            } else {
                if guess_number < secret_number {
                    return (1, self.attempts_player2.read()); // 1 means "higher"
                } else if guess_number > secret_number {
                    return (2, self.attempts_player2.read()); // 2 means "lower"
                } else {
                    return (0, self.attempts_player2.read()); // 0 means "correct"
                }
            }
        }

        fn get_attempts(ref self: ContractState) -> (u32, u32) {
            // Return the number of attempts for both players
            return (self.attempts_player1.read(), self.attempts_player2.read());
        }

       fn declare_winner(ref self: ContractState) -> u8 {
    // Determine the closest guess to the secret number
    let secret_number = self.secret_number.read();
    let guess1 = self.guess_player1.read();
    let guess2 = self.guess_player2.read();

    // Calculate absolute differences manually
    let diff1 = if guess1 > secret_number { 
        guess1 - secret_number 
    } else { 
        secret_number - guess1 
    }; // Absolute difference for Player 1

    let diff2 = if guess2 > secret_number { 
        guess2 - secret_number 
    } else { 
        secret_number - guess2 
    }; // Absolute difference for Player 2

    // Determine winner
    if diff1 < diff2 {
        return 0; // Player 1 wins
    } else if diff2 < diff1 {
        return 1; // Player 2 wins
    } else {
        return 2; // Tie
    }
}

    }
}
