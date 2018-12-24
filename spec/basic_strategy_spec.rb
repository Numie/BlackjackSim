require 'rspec'
require 'basic_strategy'

describe BasicStrategy do
  let(:hand) { double('hand') }
  let(:upcard) { double('card') }

  describe '::action' do
    context 'when a hand is a pair' do
      it 'finds the correct basic strategy' do
        allow(BasicStrategy).to receive(:pair?).and_return(true)
        expect(BasicStrategy).to receive(:action_with_pair)
        BasicStrategy.action(hand, upcard)
      end
    end
    context 'when a hand is soft' do
      it 'finds the correct basic strategy' do
        allow(BasicStrategy).to receive(:pair?).and_return(false)
        allow(BasicStrategy).to receive(:soft?).and_return(true)
        expect(BasicStrategy).to receive(:action_with_soft_hand)
        BasicStrategy.action(hand, upcard)
      end
    end
    context 'when a hand is hard' do
      it 'finds the correct basic strategy' do
        allow(BasicStrategy).to receive(:pair?).and_return(false)
        allow(BasicStrategy).to receive(:soft?).and_return(false)
        expect(BasicStrategy).to receive(:action_with_hard_hand)
        BasicStrategy.action(hand, upcard)
      end
    end
  end

  describe '::pair?' do
    let(:card1) { double('card') }
    let(:card2) { double('card') }
    context 'when a hand is a pair' do
      it 'returns true' do
        allow(hand).to receive(:cards).and_return([card1, card2])
        allow(card1).to receive(:rank).and_return(:two)
        allow(card2).to receive(:rank).and_return(:two)
        bool = BasicStrategy.pair?(hand)
        expect(bool).to eq(true)
      end
    end
    context 'when a hand is not a pair' do
      it 'returns false' do
        allow(hand).to receive(:cards).and_return([card1, card2])
        allow(card1).to receive(:rank).and_return(:two)
        allow(card2).to receive(:rank).and_return(:three)
        bool = BasicStrategy.pair?(hand)
        expect(bool).to eq(false)
      end
    end
    context 'when a hand does not have two cards' do
      it 'returns false' do
        allow(hand).to receive(:cards).and_return([card1])
        allow(card1).to receive(:rank).and_return(:two)
        allow(card2).to receive(:rank).and_return(:two)
        bool = BasicStrategy.pair?(hand)
        expect(bool).to eq(false)
      end
    end
  end

  describe '::soft?' do
    let(:card1) { double('card') }
    let(:card2) { double('card') }
    context 'when a hand is hard' do
      it 'returns false' do
        allow(hand).to receive(:hard).and_return(true)
        bool = BasicStrategy.soft?(hand)
        expect(bool).to eq(false)
      end
    end
    context 'when a hand is not hard and does not contain an ace' do
      it 'returns false' do
        allow(hand).to receive(:cards).and_return([card1, card2])
        allow(hand).to receive(:hard).and_return(false)
        allow(card1).to receive(:rank).and_return(:two)
        allow(card2).to receive(:rank).and_return(:three)
        bool = BasicStrategy.soft?(hand)
        expect(bool).to eq(false)
      end
    end
    context 'when a hand is not hard and contains an ace' do
      it 'returns true' do
        allow(hand).to receive(:cards).and_return([card1, card2])
        allow(hand).to receive(:hard).and_return(false)
        allow(card1).to receive(:rank).and_return(:two)
        allow(card2).to receive(:rank).and_return(:ace)
        bool = BasicStrategy.soft?(hand)
        expect(bool).to eq(true)
      end
    end
  end

  describe '::pair_rank' do
    let(:card1) { double('card') }
    let(:card2) { double('card') }
    it 'returns the rank of a pair' do
      allow(hand).to receive(:cards).and_return([card1, card2])
      allow(card1).to receive(:rank).and_return(:two)
      allow(card2).to receive(:rank).and_return(:two)
      rank = BasicStrategy.pair_rank(hand)
      expect(rank).to eq(:two)
    end
  end

  describe '::action_with_pair' do
    context 'when the rank is 2' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:two)
      end
      context 'when the upcard is less than 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is greater than 7' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(8)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 3' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:three)
      end
      context 'when the upcard is less than 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is greater than 7' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(8)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 4' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:four)
      end
      context 'when the upcard is 5' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(5)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 6' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is less than 5' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(4)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
      context 'when the upcard is greater than 6' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 5' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:five)
      end
      context 'when the upcard is less than 10' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(9)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is 10' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(10)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
      context 'when the upcard is an Ace' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(11)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 6' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:six)
      end
      context 'when the upcard is less than 6' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(5)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 6' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is greater than 6' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 7' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:seven)
      end
      context 'when the upcard is less than 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is greater than 7' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(8)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the rank is 8' do
      it 'split' do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:eight)
        allow(upcard).to receive(:value).and_return(rand(2..11))
        action = BasicStrategy.action_with_pair(hand, upcard)
        expect(action).to eq(:split)
      end
    end

    context 'when the rank is 9' do
      before(:each) do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:nine)
      end
      context 'when the upcard is less than 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 7' do
        it 'split' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:stay)
        end
      end
      context 'when the upcard is 8' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(8)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is 9' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(9)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:split)
        end
      end
      context 'when the upcard is greater than 9' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(10)
          action = BasicStrategy.action_with_pair(hand, upcard)
          expect(action).to eq(:stay)
        end
      end
    end

    context 'when the rank is 10' do
      it 'stay' do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:ten)
        allow(upcard).to receive(:value).and_return(rand(2..11))
        action = BasicStrategy.action_with_pair(hand, upcard)
        expect(action).to eq(:stay)
      end
    end

    context 'when the rank is Ace' do
      it 'stay' do
        allow(BasicStrategy).to receive(:pair_rank).and_return(:ace)
        allow(upcard).to receive(:value).and_return(rand(2..11))
        action = BasicStrategy.action_with_pair(hand, upcard)
        expect(action).to eq(:split)
      end
    end
  end

  describe '::action with soft hand' do
    context 'when the value is 13 or 14' do
      before(:each) do
        allow(hand).to receive(:value).and_return(13)
      end
      context 'when the upcard is 5' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(5)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is 6' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is less than 5' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(4)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
      context 'when the upcard is greater than 6' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the value is 15 or 16' do
      before(:each) do
        allow(hand).to receive(:value).and_return(15)
      end
      context 'when the upcard is between 4 and 6' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(4)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)

          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is less than 4' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(3)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
      context 'when the upcard is greater than 6' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the value is 17' do
      before(:each) do
        allow(hand).to receive(:value).and_return(17)
      end
      context 'when the upcard is between 3 and 6' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(3)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)

          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is less than 3' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(2)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
      context 'when the upcard is greater than 6' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the value is 18' do
      before(:each) do
        allow(hand).to receive(:value).and_return(18)
      end
      context 'when the upcard is between 3 and 6' do
        it 'double' do
          allow(upcard).to receive(:value).and_return(3)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)

          allow(upcard).to receive(:value).and_return(6)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:double)
        end
      end
      context 'when the upcard is 2, 7 or 8' do
        it 'stay' do
          allow(upcard).to receive(:value).and_return(2)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:stay)

          allow(upcard).to receive(:value).and_return(7)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:stay)

          allow(upcard).to receive(:value).and_return(8)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:stay)
        end
      end
      context 'when the upcard is greater than 8' do
        it 'hit' do
          allow(upcard).to receive(:value).and_return(9)
          action = BasicStrategy.action_with_soft_hand(hand, upcard)
          expect(action).to eq(:hit)
        end
      end
    end

    context 'when the value is 19' do
      before(:each) do
        allow(hand).to receive(:value).and_return(19)
      end
      it 'stay' do
        allow(upcard).to receive(:value).and_return(rand(2..11))
        action = BasicStrategy.action_with_soft_hand(hand, upcard)
        expect(action).to eq(:stay)
      end
    end
  end
end
