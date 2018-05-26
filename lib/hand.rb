class Hand
  attr_reader :cards, :value
  attr_accessor :bet

  def initialize
    @cards = []
    @value = 0
    @bet = nil
  end

  def hit(shoe)
    receive_card(shoe)
  end

  def double_down(shoe)
    @doubled = true
    receive_card(shoe)
  end

  def split
    hand1 = Hand.new
    hand2 = Hand.new

    card1 = @cards[0]
    card2 = @cards[1]

    hand1.cards << card1
    hand1.send(:add_card_to_value, card1)
    hand1.bet = @bet

    hand2.cards << card2
    hand2.send(:add_card_to_value, card2)
    hand2.bet = @bet

    return [hand1, hand2]
  end

  def blackjack?
    @blackjack ||= (@value == 21 && @cards.length == 2)
  end

  def busted?
    @busted ||= (@value > 21)
  end

  def doubled?
    @doubled == true
  end

  private

  def receive_card(shoe)
    card = shoe.draw_card
    @cards << card
    add_card_to_value(card)
    card
  end

  def add_card_to_value(card)
    if card.rank == :ace
      if @value >= 11
        @value += 1
      else
        @ace_as_11 = true
        @value += 11
      end
    else
      @value += card.value
    end

    if @value > 21 && (@ace_as_11 && !@hard)
      @hard = true
      @value -= 10
    end
  end
end
