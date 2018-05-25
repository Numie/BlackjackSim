class Hand
  attr_reader :value
  attr_accessor :bet

  def initialize
    @cards = []
    @value = 0
    @bet = nil
    @ace_as_11 = false
    @hard = false
    @busted = false
    @doubled = false
    @blackjack = false
  end

  def blackjack?
    @blackjack ||= (@value == 21 && @cards.length == 2)
  end

  def busted?
    @busted ||= (@value > 21)
  end

  private

  def add_card_to_value(card)

  end

  def receive_card(shoe)

  end
end
