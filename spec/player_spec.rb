require 'rspec'
require 'player'

describe Player do
  let(:dealer) { double('dealer') }
  let(:player) { Player.new(dealer) }
  let(:hand) { double('hand') }
  let(:shoe) { double('shoe') }

  describe '#initialize' do
    it 'sets the dealer' do
      expect(player.instance_variable_get(:@dealer)).to eq(dealer)
    end
    it 'initializes the bankroll to 0' do
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



  describe '#check_hand_status' do
    it 'is private' do
      expect{ player.check_hand_status }.to raise_error
    end

    context 'when a hand is busted' do
      before(:each) do
        player.instance_variable_set(:@current_hand, hand)
        allow(hand).to receive(:busted?).and_return(true)
        allow(hand).to receive(:bet).and_return(0)
        allow(dealer).to receive(:bankroll).and_return(0)
        allow(dealer).to receive(:bankroll=)
      end
      it 'moves to the next hand' do
        expect(player).to receive(:next_hand)
        player.send(:check_hand_status)
      end
    end

    context 'when a hand is doubled' do
      before do
        player.instance_variable_set(:@current_hand, hand)
        allow(hand).to receive(:busted?).and_return(false)
        allow(hand).to receive(:doubled?).and_return(true)
      end
      it 'moves to the next hand' do
        expect(player).to receive(:next_hand)
        player.send(:check_hand_status)
      end
    end

    context 'when a hand is neither busted nor doubled' do
      before do
        player.instance_variable_set(:@current_hand, hand)
        allow(hand).to receive(:busted?).and_return(false)
        allow(hand).to receive(:doubled?).and_return(false)
      end
      it 'continues with the current hand'
    end
  end

  describe '#next_hand' do
    let(:next_hand) { double('hand') }
    let(:card1) { double('card') }
    let(:card2) { double('card') }
    it 'is private' do
      expect{ player.next_hand }.to raise_error
    end
    it 'moves to the next hand' do
      player.instance_variable_set(:@hands, [hand, next_hand])
      player.instance_variable_set(:@current_hand_index, 0)
      allow(next_hand).to receive(:cards).and_return([card1, card2])
      player.send(:next_hand, shoe)
      expect(player.current_hand).to eq(next_hand)
    end
    it 'deals a card if a hand was split' do
      player.instance_variable_set(:@hands, [hand, next_hand])
      player.instance_variable_set(:@current_hand_index, 0)
      allow(next_hand).to receive(:cards).and_return([card1])
      allow(next_hand).to receive(:blackjack?).and_return(false)
      expect(next_hand).to receive(:receive_card)
      player.send(:next_hand, shoe)
    end
  end
end
