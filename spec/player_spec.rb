require 'rspec'
require 'player'

describe 'Player' do
  let(:deck) { double("deck")}
  subject(:player) { Player.new('david',deck)}

  describe '#initialize' do
    it 'initializes and draws from deck' do
      expect(deck).to receive(:take).with(5)
      player = Player.new('david',deck)
    end



  end


  describe '#go_fish' do
    it "adds a card to the player's hand" do
      expect(deck).to receive(:take).with(5)
      allow(player).to receive(:hand).and_return([1,2,3,4,5])
      # expect(deck).to receive(:take)
      # prev_length = player.count
      #player.go_fish
      # expect(player.count).to eq(prev_length+1)
    end
  end

  describe '#remove_quads' do
    it 'decreases number of cards in hand by 4' do


    end

    it 'increases winning cards of player by 4' do

    end
  end




end
