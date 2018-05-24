require 'rspec'
require 'hand'

describe Hand do
  let(:hand) { Hand.new }
  let(:shoe) { double('shoe') }
  let(:card) { double('card') }

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

  describe '#add_card_to_value' do
    context 'when a card is an Ace' do
      context 'when'
    end
  end

  describe '#receive_card' do
    it 'is private' do
      expect{ hand.receive_card(shoe) }.to raise_error
    end
  end

  describe '#blackjack?' do
    let(:king) { Card.new(:king, :hearts) }
    context 'when a hand is blackjack' do
      let(:ace) { Card.new(:ace, :spades) }
      it 'returns true' do
        hand.instance_variable_set(:@cards, [ace, king])
        expect(hand.blackjack?).to eq(true)
      end
    end

    context 'when a hand is not blackjack but contains blackjack cards' do
      let(:ace) { Card.new(:ace, :spades) }
      let(:three) { Card.new(:three, :diamonds) }
      it 'returns false' do
        hand.instance_variable_set(:@cards, [ace, king, three])
        expect(hand.blackjack?).to eq(false)
      end
    end

    context 'when a hand is not blackjack but has a value of 21' do
      let(:three) { Card.new(:three, :diamonds) }
      let(:eight) { Card.new(:eight, :spades) }
      it 'returns false' do
        hand.instance_variable_set(:@cards, [king, three, eight])
        expect(hand.blackjack?).to eq(false)
      end
    end
  end

  describe '#busted?' do
    let(:king) { Card.new(:king, :hearts) }
    let(:three) { Card.new(:three, :diamonds) }
    context 'when a hand is not busted' do
      it 'returns false' do
        hand.instance_variable_set(:@cards, [king, three])
        expect(hand.busted?).to eq(false)
      end
    end

    context 'when a hand is busted' do
      let(:queen) { Card.new(:queen, :clubs) }
      it 'returns true' do
        hand.instance_variable_set(:@cards, [king, three, queen])
        expect(hand.busted?).to eq(true)
      end
    end
  end
end
