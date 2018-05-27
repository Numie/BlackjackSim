require_relative 'hand'

class Player
  attr_reader :hands, :current_hand
  attr_accessor :bankroll

  def initialize(dealer)
    @dealer = dealer
    @bankroll = 0
    @hands = [Hand.new]
    @current_hand_index = 0
    @current_hand = @hands[@current_hand_index]
  end

  def place_bet(hand, amt)
    @bankroll -= amt
    hand.bet = amt
  end

  def receive_winnings(hand)
    @bankroll += (hand.blackjack? ? hand.bet * 1.5 : hand.bet)
  end

  private

  def check_hand_status
    if @current_hand.busted?
      @dealer.bankroll += @current_hand.bet
      next_hand
    elsif @current_hand.doubled?
      next_hand
    else
    end
  end

  def next_hand
    @current_hand_index += 1
    @current_hand = @hands[@current_hand_index]

    
  end

  def end_turn

  end
end
