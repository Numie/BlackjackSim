require 'rspec'
require 'hand'

describe Hand do
  let(:hand) { Hand.new }

  describe '#initialize' do
    it 'initializes cards to an empty array' do
      expect(hand.instance_variable_get(:@cards)).to eq([])
    end
    it 'has a value of 0' do
      expect(hand.instance_variable_get(:@value)).to eq(0)
    end
    it 'does not have a bet' do
      expect(hand.instance_variable_get(:@bet)).to eq(nil)
    end
    it 'does not have an Ace as 11' do
      expect(hand.instance_variable_get(:@ace_as_11)).to eq(false)
    end
    it 'is not hard' do
      expect(hand.instance_variable_get(:@is_hard)).to eq(false)
    end
    it 'is not busted' do
      expect(hand.instance_variable_get(:@is_busted)).to eq(false)
    end
    it 'is not doubled' do
      expect(hand.instance_variable_get(:@is_doubled)).to eq(false)
    end
    it 'is not blackjack' do
      expect(hand.instance_variable_get(:@is_blackjack)).to eq(false)
    end
  end

  describe 'receive_card' do
    it 'is private' do
      expect{ hand.receive_card(shoe) }.to raise_error
    end
  end
end
