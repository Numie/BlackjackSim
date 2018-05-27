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

  def hit(shoe)
    @current_hand.hit(shoe)
    check_hand_status
  end

  def stand(shoe)
    next_hand(shoe)
  end

  def double_down(shoe)
    @bankroll -= @current_hand.bet
    @current_hand.double_down(shoe)
    check_hand_status
  end

  private

  def check_hand_status
    if @current_hand.busted?
      @dealer.bankroll += @current_hand.bet
      next_hand
    elsif @current_hand.doubled?
      next_hand
    end
  end

  def next_hand(shoe)
    @current_hand_index += 1
    @current_hand = @hands[@current_hand_index]
    return if @current_hand.nil?
    # perform basic strategy action

    if @current_hand.cards.length == 1
      @current_hand.send(:receive_card, shoe)
      next_hand if @current_hand.blackjack?
    end
  end

  def end_turn

  end
end
