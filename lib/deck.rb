require_relative 'card'

class Deck

  attr_reader :cards

  def self.create_cards
    cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        cards.push(Card.new(suit,value))
      end
    end
    cards
  end


  def initialize
    @cards = Deck.create_cards.shuffle
  end

  def take(n)
    if n>count
      raise ArgumentError.new('not enough cards')
    else
      cards.pop(n)
    end
  end

  def count
    cards.length
  end

  def empty?
    cards.length==0
  end

  def to_s
    cards.each do |card|
      puts card
    end
  end

end
