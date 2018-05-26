require_relative 'hand'

class Player
  attr_reader :hands, :current_hand
  attr_accessor :bankroll

  def initialize
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
end
