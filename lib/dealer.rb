require_relative 'hand'

class Dealer
  def initialize
    @hand = Hand.new
  end

  def hit(shoe)
    @hand.hit(shoe)
  end
end
