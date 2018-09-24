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
end
