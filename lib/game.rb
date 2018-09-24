require_relative 'dealer'
require_relative 'player'
require_relative 'shoe'

class Game
  attr_reader :dealer, :player
  attr_accessor :shoe

  def initialize
    @dealer = Dealer.new
    @player = Player.new(@dealer)
    @shoe = Shoe.new
  end

  def all_hands
    [player.hands, dealer.hand].flatten
  end

  def deal_hand
    2.times do
      all_hands.each { |hand| hand.receive_card(shoe) }
    end
  end

  def end_of_shoe?
    shoe.count < 104
  end

  def shuffle
    self.shoe = Shoe.new
  end
end
