class Card
  attr_reader :suit, :value

  SUITS = [:spades, :diamonds, :clubs, :hearts]

  VALUES = [:two, :three, :four, :five, :six, :seven, :eight,
  :nine, :ten, :jack, :queen, :king, :ace]

  def initialize(suit,value)
    @suit=suit
    @value = value
  end

  def ==(other)
    suit == other.suit && value == other.value
  end

  def to_s
    return "#{value} of #{suit}"
  end

end
