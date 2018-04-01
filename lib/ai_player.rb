require 'byebug'

class AIPlayer

  attr_reader :name, :winning_cards

  def initialize(name,deck)
    @name = name
    @hand = deck.take(5)
    @deck = deck
    @winning_cards = []
    @mrroboto = {}
  end

  def to_s
    puts name
    hand.each do |card|
      puts card
    end
  end

  def add_players_arr(arr)
    @players = arr.select { |player| player.name != name}
  end

  def count
    hand.length
  end

  def get_input
    # debugger
    input = []
    hand.each do |card|
      if mrroboto[card.value] != nil && mrroboto[card.value].length > 0
        input.push(card.value)
        #pop because player that eventually gets asked must surrender all of card.value
        removed_player = mrroboto[card.value].pop
        input.push(removed_player.name)
        return input
      end
    end
    input.push(hand[0].value)
    input.push(players[0].name)
    return input
    # value = gets.chomp.to_sym
    #no prompts. the AI player does everything automatically. from the outside though,
    #it's implemented like player.rb

  end

  def add_memory(value, target_player)
    if target_player.name == name
      return nil
    end
    if mrroboto[value] == nil
      mrroboto[value] = [target_player]
    else
      mrroboto[value].push(target_player)
    end
  end

  def remove_memory(value, target_player)
    if target_player.name == name
      return nil
    end
    if mrroboto[value] !=nil
      mrroboto[value].delete(target_player)
    end
  end

  def include?(value)
    hand.any?{ |card| card.value == value}
  end

  def remove(value)
    cards = hand.select { |card| card.value == value}
    self.hand = hand.select { |card| card.value != value}
    return cards
  end

  #adds other player's cards to self hand
  def add(cards)
    self.hand = hand + cards
  end


  def go_fish
    self.hand = hand + @deck.take(1)
  end

  def remove_quads
    quads = find_quads
    hand.each do |card|
      if quads[card.value] != nil
        @winning_cards.push(card)
      end
    end
    @hand = @hand.select { |card| quads[card.value] == nil}
  end


  def find_quads
    counter_hsh = Hash.new(0)
    hand.each do |card|
      counter_hsh[card.value] += 1
    end
    quads = counter_hsh.select{ |k,v| v==4 }
    quads
  end

  #return how many matches (four of a kind) the player has
  def matches
    winning_cards.length / 4
  end

  protected

  attr_reader :players
  attr_accessor :hand, :mrroboto



end
