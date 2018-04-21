require_relative 'deck'

class Player

  attr_reader :name, :winning_cards

  def initialize(name,deck)
    @name = name
    @hand = deck.take(5)
    @deck = deck
    @winning_cards = []
  end

  def to_s
    hand.each do |card|
      puts card
    end
    return ''
  end

  def count
    hand.length
  end

  def get_input
    puts "#{name}, pick one of your cards (no spaces please):\n "
    puts self
    value = gets.chomp.to_sym
    if !include?(value)
      raise ArgumentError.new('Not one of your cards!')
    else
      puts 'Pick a player: '
      player = gets.chomp
      return [value,player]
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

  attr_accessor :hand

end
