require_relative 'hand'

class Dealer
  attr_reader :hand

  def initialize
    @hand = Hand.new
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
