require 'rspec'
require 'deck'


describe 'Deck' do
  subject(:deck) { Deck.new }

  describe 'initialize' do

    it 'initializes with 52 cards' do
      expect(deck.cards.length).to eq(52)
    end

    it 'initializes with all unique cards' do
      expect(deck.cards.uniq.length).to eq(deck.cards.length)
    end
  end

  it 'tracks the amount of cards' do
    expect(deck.count).to eq(deck.cards.length)
  end



  describe 'take' do
    it 'pops off a Card when a player needs to go fish' do
      expect(deck.take(1)[0].is_a?(Card)).to be true
    end

    it 'does not allow to pop if no cards left' do
      expect{deck.take(53)}.to raise_error('not enough cards')
    end

  end

end
