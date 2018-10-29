module BasicStrategy
  module_function

  def action(hand, upcard)
    if pair?
      action_with_pair(hand, upcard)
    end
  end

  def pair?(hand)
    return false unless hand.cards.length == 2
    hand.cards.first.rank == hand.cards.last.rank
  end

  def pair_rank(hand)
    raise 'Not a pair!' unless pair?(hand)
    hand.cards.first.rank
  end

  def action_with_pair(hand, upcard)
    case pair_rank(hand)
    when :two, :three
      upcard.value <= 7 ? :split : :hit
    when :four
      upcard.value == 5 || upcard.value == 6 ? :split : :hit
    when :five
      upcard.value < 10 ? :double : :hit
    when :six
      upcard.value <= 6 ? :split : :hit
    when :seven
      upcard.value <= 7 ? :split : :hit
    when :nine
      upcard.value <= 9 && upcard.value != 7 ? :split : :stay
    when :eight, :ace
      :split
    else
      :stay
    end
  end
end
