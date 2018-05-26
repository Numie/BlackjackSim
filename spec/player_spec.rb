require 'rspec'
require 'player'

describe Player do
  let(:player) { Player.new }
  let(:hand) { double('hand') }

  describe '#initialize' do
    it 'initializes the bankroll do 0' do
      expect(player.bankroll).to eq(0)
    end
    it 'initializes hands to an array' do
      expect(player.hands).to be_a(Array)
    end
    it 'starts a Player with one hand' do
      expect(player.hands.count { |el| el.is_a?(Hand) }).to eq(1)
    end
    it 'identifies a Player\'s first hand' do
      expect(player.current_hand).to eq(player.hands.first)
    end
  end

  describe '#place_bet' do
    it 'reduces the bankroll by the bet amount' do
      allow(hand).to receive(:bet=)
      player.place_bet(hand, 50)
      expect(player.bankroll).to eq(-50)
    end
    it 'sets a hand\'s bet' do
      real_hand = Hand.new
      player.place_bet(real_hand, 50)
      expect(real_hand.bet).to eq(50)
    end
  end

  describe '#receive_winnings' do
    before(:each) { allow(hand).to receive(:bet).and_return(50) }
    context 'when a hand is blackjack' do
      it 'pays 3 to 2' do
        allow(hand).to receive(:blackjack?).and_return(true)
        player.receive_winnings(hand)
        expect(player.bankroll).to eq(75)
      end
    end

    context 'when a hand is not blackjack' do
      it 'pays even money' do
        allow(hand).to receive(:blackjack?).and_return(false)
        player.receive_winnings(hand)
        expect(player.bankroll).to eq(50)
      end
    end
  end
end
