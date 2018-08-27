require_relative 'hand'

class Player
  attr_reader :dealer, :hands
  attr_accessor :bankroll, :current_hand_index, :current_hand

  def initialize(dealer)
    @dealer = dealer
    @bankroll = 0
    @hands = [Hand.new]
    @current_hand_index = 0
    @current_hand = @hands[@current_hand_index]
  end

  def place_bet(hand, amt)
    self.bankroll -= amt
    hand.bet = amt
  end

  def receive_winnings(hand)
    self.bankroll += (hand.blackjack? ? hand.bet * 1.5 : hand.bet)
  end

  def hit(shoe)
    current_hand.hit(shoe)
    check_hand_status(shoe)
  end

  def stand(shoe)
    next_hand(shoe)
  end

  def double_down(shoe)
    self.bankroll -= current_hand.bet
    current_hand.double_down(shoe)
    check_hand_status(shoe)
  end

  def split(shoe)
    hands.delete_at(current_hand_index)
    new_hands = current_hand.split(shoe)
    hands.insert(current_hand_index, *new_hands)
    self.current_hand = hands[current_hand_index]
    hit(shoe)
  end

  private

  def check_hand_status(shoe)
    if current_hand.busted?
      dealer.bankroll += current_hand.bet
      next_hand(shoe)
    elsif current_hand.doubled?
      next_hand(shoe)
    end
  end

  def next_hand(shoe)
    self.current_hand_index += 1
    self.current_hand = hands[current_hand_index]
    return if current_hand.nil?
    # perform basic strategy action

    if current_hand.cards.length == 1
      current_hand.send(:receive_card, shoe)
      next_hand if current_hand.blackjack?
    end
  end

  def end_turn

  end
end
