require 'rspec'
require 'card'

describe "Card" do
  subject(:card) { Card.new(:spade, :two)}
  let(:dupe) { Card.new(:spade, :two)}

  it "contains a suit" do
    expect(card.suit).to be(:spade)
  end

  it 'contains a value' do
    expect(card.value).to be(:two)
  end

  it 'correctly checks equality' do
    expect(card).to eq(dupe)
  end

end
