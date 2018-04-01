require_relative 'player'
require_relative 'ai_player'
require 'byebug'

class Game

  attr_reader :players, :current_player, :player_index, :deck, :winners

  def initialize(deck)
    @deck = deck
    @players = []
    create_players(deck)
    create_ai_players(deck)
    check_players
    update_ai_players
    @current_player_index = 0
    @current_player = players[0]
    @player_index = index_players
    @winners = []
    @empty_players = []
  end

  def check_players
    if players.length > 10
      raise ArgumentError.new("Cannot have more than 10 players bro")
    end
    name_hash = Hash.new(0)
    players.each do |player|
      if name_hash[player.name] > 0
        raise ArgumentError.new('It is impossible for two people to have the same name')
      else
        name_hash[player.name] += 1
      end
    end
  end

  def create_players(deck)
    puts "Enter the names for all players below (separated by SPACES): "
    input = gets.chomp.split(' ')
    input.each do |player|
      @players.push(Player.new(player, deck))
    end
  end

  def create_ai_players(deck)
    puts "Enter the names for all AI players below (use spaces!): "
    input = gets.chomp.split(' ')
    input.each do |player|
      @players.push(AIPlayer.new(player, deck))
    end
  end

  def update_ai_players
    players.each do |player|
      if player.is_a?(AIPlayer)
        player.add_players_arr(players)
      end
    end
  end

  def index_players
    hsh = {}
    players.each do |player|
      hsh[player.name] = player
    end
    hsh
  end

  def update_ai_memories(value, target_player)
    players.each do |player|
      if player.is_a?(AIPlayer)
        player.add_memory(value,target_player)
      end
    end
  end

  def remove_ai_memories(value, target_player)
    players.each do |player|
      if player.is_a?(AIPlayer)
        player.remove_memory(value, target_player)
      end
    end
  end

  def play
    puts '######################################################'
    puts 'MUST INPUT STRINGS FOR CARDS (i.e. "five")'
    puts 'PLEASE DO THIS'
    puts '######################################################'

    while !game_over?
      begin
        # debugger
        input = current_player.get_input
        if !exists?(input[1])
          puts input[1]
          raise ArgumentError.new('That player does NOT EXIST!')
        elsif player_index[input[1]] == current_player
          raise ArgumentError.new('CANNOT ASK YOURSELF DUDE')
        end
      rescue ArgumentError => e
        puts e.message
        retry
      end
      value = input[0]
      asked_player = player_index[input[1]]
      #at this point we know the input is valid, aka the current player must
      #have card/s of value in his/her hand. so we can update all AI players here.
      #just kidding, let's update AI players inside the conditionals
      puts "#{current_player.name} ASKS #{asked_player.name} FOR #{value}!"
      if asked_player.include?(value)
        cards = asked_player.remove(value)
        current_player.add(cards)
        current_player.remove_quads

        puts "#{asked_player.name} GIVES #{cards.length} CARDS TO #{current_player.name}!"
        puts "Deck has #{deck.count} cards remaining"
        remove_ai_memories(value, asked_player)
        update_ai_memories(value, current_player)

        if current_player.count==0
          remove_ai_memories(value, current_player)
          remove_empty_players
          puts "#{current_player.name} is OUTTA HERE!"
          switch_players
        elsif asked_player.count == 0
          remove_empty_players
          puts "#{asked_player.name} is OUTTA HERE!"
          switch_players
        end
      else
        puts "#{current_player.name} MUST GO FISH!"
        current_player.go_fish
        current_player.remove_quads
        if current_player.count == 0
          remove_ai_memories(value,current_player)
          remove_empty_players
          puts "#{current_player.name} is OUTTA HERE!"
        else
          update_ai_memories(value,current_player)
        end
        switch_players
        puts "#{current_player.name}'s turn"
      end
      remove_empty_players
    end
    find_winners
    congrats
  end

  def exists?(player)
    return player_index[player] != nil
  end

  #since we have ai players we need to remove them from the game if they
  #run out of cards in their hand before the deck runs out.
  def remove_empty_players
    remaining_players = players.select do |player|
      player.count > 0
    end
    discarded_players = players.select do |player|
      player.count <=0
    end
    @empty_players += discarded_players
    @players = remaining_players
  end

  #if there's one player left, he/she keeps drawing. eventually
  #that player runs out of cards by matching everything, so
  #remove_empty_players in line 136 will set @players to []
  #which leads to an % by 0 error below. let's fix that
  def switch_players
    if players.length == 0
      return
    end
    @current_player_index = (@current_player_index + 1) % players.length
    @current_player = players[@current_player_index]
  end


  def game_over?
    @deck.count==0 || players.length == 0
  end

  #find player/s with the most matches
  def find_winners
    # debugger
    all_players = @empty_players + players
    sorted_players = all_players.sort_by { |player| player.matches }
    most_matches = sorted_players[-1].matches
    i = all_players.length-1
    while sorted_players[i].matches == most_matches do
      winners.push(sorted_players[i])
      i -= 1
      break if i < 0
    end
    @most_matches = most_matches
  end

  def congrats
    out = 'Congrats to '
    winners_arr = []
    @winners.each do |winner|
      winners_arr.push(winner.name)
    end
    out += winners_arr.join(', ')
    out.concat(" on your #{@most_matches} matches! WINNER WINNER CHICKEN DINNER!")
    puts out
  end

end



if __FILE__ == $PROGRAM_NAME
  d = Deck.new
  g = Game.new(d)
  g.play
end
