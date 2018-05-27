require 'rspec'
require 'hand'
require 'card'

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
  end

  describe '#hit' do
    before(:each) do
      allow(shoe).to receive(:draw_card).and_return(card)
      allow(card).to receive(:rank).and_return(:ace)
    end
    it 'receives a card' do
      expect(hand).to receive(:receive_card)
      hand.hit(shoe)
    end
    it 'returns the received card' do
      expect(hand.hit(shoe)).to respond_to(:rank)
    end
  end

  describe '#double_down' do
    before(:each) do
      allow(shoe).to receive(:draw_card).and_return(card)
      allow(card).to receive(:rank).and_return(:ace)
      hand.bet = 50
    end
    it 'registers a Hand as doubled down' do
      hand.double_down(shoe)
      expect(hand.instance_variable_get(:@doubled)).to eq(true)
    end
    it 'doubles a Hand\'s bet' do
      hand.double_down(shoe)
      expect(hand.bet).to eq(100)
    end
    it 'receives a card' do
      expect(hand).to receive(:receive_card)
      hand.hit(shoe)
    end
    it 'returns the received card' do
      expect(hand.hit(shoe)).to respond_to(:rank)
    end
  end

  describe '#split' do
    before(:each) do
      hand.instance_variable_set(:@cards, [card, card])
      allow(card).to receive(:rank).and_return(:ace)
    end
    it 'returns a Array' do
      expect(hand.split).to be_a(Array)
    end
    it 'splits a Hand into two hands' do
      expect(hand.split.count { |el| el.is_a?(Hand) }).to eq(2)
    end
    it 'gives each Hand one card' do
      expect(hand.split.all? { |hand| hand.instance_variable_get(:@cards).length == 1 }).to eq(true)
    end
    it 'gives each Hand a bet equal to the original Hand\'s bet' do
      hand.bet = 50
      expect(hand.split.all? { |hand| hand.bet == 50 }).to eq(true)
    end
  end

  describe '#blackjack?' do
    context 'when a hand is blackjack' do
      it 'returns true' do
        hand.instance_variable_set(:@cards, [card, card])
        hand.instance_variable_set(:@value, 21)
        expect(hand.blackjack?).to eq(true)
      end
    end

    context 'when a hand is not blackjack but has a value of 21' do
      it 'returns false' do
        hand.instance_variable_set(:@cards, [card, card, card])
        hand.instance_variable_set(:@value, 21)
        expect(hand.blackjack?).to eq(false)
      end
    end
  end

  describe '#busted?' do
    context 'when a hand is not busted' do
      it 'returns false' do
        hand.instance_variable_set(:@value, 21)
        expect(hand.busted?).to eq(false)
      end
    end

    context 'when a hand is busted' do
      it 'returns true' do
        hand.instance_variable_set(:@value, 22)
        expect(hand.busted?).to eq(true)
      end
    end
  end

  describe '#doubled?' do
    context 'when a hand is not doubled' do
      it 'returns false' do
        expect(hand.doubled?).to eq(false)
      end
    end

    context 'when a hand is doubled' do
      it 'returns true' do
        hand.instance_variable_set(:@doubled, true)
        expect(hand.doubled?).to eq(true)
      end
    end
  end

  describe '#receive_card' do
    before(:each) do
      allow(shoe).to receive(:draw_card).and_return(card)
      allow(card).to receive(:rank).and_return(:ace)
    end
    it 'is private' do
      expect{ hand.receive_card(shoe) }.to raise_error
    end
    it 'adds the card to a Hand\'s cards' do
      hand.send(:receive_card, shoe)
      expect(hand.instance_variable_get(:@cards)).to include(card)
    end
    it 'adds the card\'s value to a Hand\'s value' do
      expect(hand).to receive(:add_card_to_value)
      hand.send(:receive_card, shoe)
    end
    it 'returns the received card' do
      expect(hand.send(:receive_card, shoe)).to eq(card)
    end
  end

  describe '#add_card_to_value' do
    it 'is private' do
      expect{ hand.add_card_to_value(card) }.to raise_error
    end
    context 'when a card is an Ace' do
      before(:each) { allow(card).to receive(:rank).and_return(:ace) }
      context 'when a Hand has a value greater than or equal to 11' do
        it 'adds 1 to the value' do
          hand.instance_variable_set(:@value, 11)
          hand.send(:add_card_to_value, card)
          expect(hand.value).to eq(12)
        end
      end

      context 'when a Hand has a value less than 11' do
        before(:each) do
          hand.instance_variable_set(:@value, 10)
          hand.send(:add_card_to_value, card)
        end
        it 'adds 11 to the value' do
          expect(hand.value).to eq(21)
        end
        it 'registers an Ace being used as 11' do
          expect(hand.instance_variable_get(:@ace_as_11)).to eq(true)
        end
      end
    end

    context 'when a card is not an Ace' do
      before(:each) do
        allow(card).to receive(:rank).and_return(:jack)
        allow(card).to receive(:value).and_return(10)
      end
      it 'adds the card\'s value to the value' do
        hand.instance_variable_set(:@value, 10)
        hand.send(:add_card_to_value, card)
        expect(hand.value).to eq(20)
      end
    end

    context 'when a Hand is soft' do
      before(:each) do
        hand.instance_variable_set(:@ace_as_11, true)
        hand.instance_variable_set(:@hard, false)
        allow(card).to receive(:rank).and_return(:eight)
        allow(card).to receive(:value).and_return(8)
      end
      context 'when a Hand would bust' do
        before(:each) do
          hand.instance_variable_set(:@value, 20)
          hand.send(:add_card_to_value, card)
        end
        it 'deducts 10 from the value' do
          expect(hand.value).to eq(18)
        end
        it 'registers the Hand as hard' do
          expect(hand.instance_variable_get(:@hard)).to eq(true)
        end
      end

      context 'when a Hand would not bust' do
        before(:each) do
          hand.instance_variable_set(:@value, 6)
          hand.send(:add_card_to_value, card)
        end
        it 'adds the card\'s value as normal' do
          expect(hand.value).to eq(14)
        end
        it 'does not register the Hand as hard' do
          expect(hand.instance_variable_get(:@hard)).to eq(false)
        end
      end
    end
  end
end
