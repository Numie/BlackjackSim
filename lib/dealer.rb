require_relative 'hand'

class Dealer
  attr_reader :hand

  def initialize
    @hand = Hand.new
  end

  def upcard
    raise 'No upcard unless there are two cards' unless hand.cards.length == 2
    hand.cards.first
  end

  def play_hand(shoe)
    while hand.value < 17
      hand.hit(shoe)
    end
  end

  def hit(shoe)
    hand.hit(shoe)
  end
end
