require_relative 'card'

class Shoe
  attr_reader :cards

  def self.create_shoe
    shoe = []

    Card.ranks.each do |rank|
      Card.suits.each do |suit|
        shoe << Card.new(rank, suit)
      end
    end

    3.times do
      shoe = shoe.concat(shoe)
    end

    shoe.shuffle
  end

  def initialize
    @cards = Shoe.create_shoe
  end

  def draw_card
    cards.shift
  end

  def count
    cards.length
  end
end
