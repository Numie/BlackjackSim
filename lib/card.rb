class Card
  SUITS = [
    :hearts,
    :diamonds,
    :spades,
    :clubs
  ]

  RANKS = {
    ace: 11,
    king: 10,
    queen: 10,
    jack: 10,
    ten: 10,
    nine: 9,
    eight: 8,
    seven: 7,
    six: 6,
    five: 5,
    four: 4,
    three: 3,
    two: 2
  }

  attr_reader :rank

  def self.suits
    SUITS
  end

  def self.ranks
    RANKS.keys
  end

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def to_s
    "#{self.rank} of #{self.instance_variable_get(:@suit)}"
  end

  def value
    RANKS[@rank]
  end
end
