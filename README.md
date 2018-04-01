# go-fish
Ruby OOP implementation of go-fish with optional AI players. 

Game rules - https://en.wikipedia.org/wiki/Go_Fish

You need to have Ruby installed on your machine to play. Make sure your current directory is the 'lib' folder, and run 'ruby game.rb' in your terminal. The game is played in the terminal. 

You have the option of specifying human or AI players, or both. To save you the trouble of scrolling through text, a human player's current hand is printed to terminal when it's his/her turn - this makes selecting a card value to guess easier. The game is over when the deck runs out of cards, or every player in the game has 0 cards in his/her hand. The winner is the player/players with the most matches (sets of 4 of a kind). 
