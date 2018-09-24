require 'rspec'
require 'card'
require 'dealer'

describe Dealer do
  let(:dealer) { Dealer.new }
  let(:hand) { double('hand') }
  let(:shoe) { double('shoe') }

  describe '#initialize' do
    it 'has a hand' do
      expect(dealer.hand).to be_a(Hand)
    end
  end

  describe '#upcard' do
    let(:card1) { Card.new(:ace, :hearts) }
    let(:card2) { Card.new(:ace, :spades) }
    before(:each) do
      allow(dealer).to receive(:hand).and_return(hand)
      allow(hand).to receive(:cards).and_return([card1, card2])
    end
    it 'returns the first card in a dealer\'s hand' do
      expect(dealer.upcard).to eq(card1)
    end
  end

  describe '#play_hand' do
    let(:real_hand) { Hand.new }
    before(:each) do
      dealer.instance_variable_set(:@hand, real_hand)
    end
    it 'stays on 17' do
      real_hand.instance_variable_set(:@value, 17)
      expect(real_hand).to_not receive(:hit)
      dealer.play_hand(shoe)
    end
  end

  describe '#hit' do
    it 'hits the Dealer\'s hand' do
      dealer.instance_variable_set(:@hand, hand)
      allow(hand).to receive(:hit)
      expect(hand).to receive(:hit)
      dealer.hit(shoe)
    end
  end
end
