require 'rspec'
require 'game'
require 'dealer'
require 'player'
require 'shoe'

describe Game do
  let(:game) { Game.new }
  let(:dealer) { game.dealer }
  let(:player) { game.player }
  let(:shoe) { game.shoe }

  describe '#initialize' do
    it 'has a dealer' do
      expect(dealer).to be_a(Dealer)
    end
    it 'has a player' do
      expect(player).to be_a(Player)
    end
    it 'has a shoe' do
      expect(shoe).to be_a(Shoe)
    end
  end

  describe '#all_hands' do
    it 'returns an array of all hands' do
      expect(game.all_hands).to eq([player.hands.first, game.dealer.hand])
    end
  end

  describe '#deal_hand' do
    it 'deals two cards to each hand' do
      game.deal_hand
      game.all_hands.each do |hand|
        expect(hand.cards.count).to eq(2)
      end
    end
  end

  describe '#end_of_shoe?' do
    context 'when there are 104 cards remaining' do
      it 'returns false' do
        allow(shoe).to receive(:count).and_return(104)
        expect(game.end_of_shoe?).to eq(false)
      end
    end
    context 'when there are more than 104 cards remaining' do
      it 'returns false' do
        allow(shoe).to receive(:count).and_return(105)
        expect(game.end_of_shoe?).to eq(false)
      end
    end
    context 'when there are fewer than 104 cards remaining' do
      it 'returns false' do
        allow(shoe).to receive(:count).and_return(103)
        expect(game.end_of_shoe?).to eq(true)
      end
    end
  end

  describe '#shuffle' do
    it 'creates a new shoe' do
      beginning_shoe = shoe
      game.shuffle
      ending_shoe = game.shoe
      expect(beginning_shoe).to_not eq(ending_shoe)
    end
  end
end
