class Hand
  attr_reader :cards
  attr_accessor :value, :doubled, :bet, :ace_as_11, :hard

  def initialize
    @cards = []
    @value = 0
    @bet = nil
  end

  def hit(shoe)
    receive_card(shoe)
  end

  def double_down(shoe)
    self.doubled = true
    self.bet *= 2
    receive_card(shoe)
  end

  def split
    hand1 = Hand.new
    hand2 = Hand.new

    card1 = cards[0]
    card2 = cards[1]

    set_up_split(hand1, card1)
    set_up_split(hand2, card2)

    [hand1, hand2]
  end

  def blackjack?
    value == 21 && cards.length == 2
  end

  def busted?
    value > 21
  end

  def doubled?
    doubled == true
  end

  def receive_card(shoe)
    card = shoe.draw_card
    cards << card
    add_card_to_value(self, card)
    card
  end

  private

  def set_up_split(hand, card)
    hand.cards << card
    add_card_to_value(hand, card)
    hand.bet = bet
  end

  def add_card_to_value(hand, card)
    if card.rank == :ace
      if hand.value >= 11
        hand.value += 1
      else
        hand.ace_as_11 = true
        hand.value += 11
      end
    else
      hand.value += card.value
    end

    if hand.value > 21 && (hand.ace_as_11 && !hand.hard)
      hand.hard = true
      hand.value -= 10
    end
  end
end
