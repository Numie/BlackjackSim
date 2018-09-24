class Game
  attr_reader :dealer, :player, :shoe

  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @shoe = Shoe.new
  end

  def all_hands
    plaer.hands.concat(dealer.hand)
  end

  def deal_hand
    2.times do
      all_hands.each { |hand| hand.receive_card(shoe) }
    end
  end
end
