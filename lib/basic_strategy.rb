module BasicStrategy
  def action(hand, upcard)
    if pair?
      action_with_pair(hand, upcard)
    end
  end

  def pair?(hand)
    return false unless hand.cards.length == 2
    hand.cards.first.rank == hands.cards.last.rank
  end

  def pair_rank
    raise 'Not a pair!' unless pair?(hand)
    hand.cards.first.rank
  end

  def action_with_pair(hand, upcard)
    if pair_rank == :two || pair_rank == :three
      upcard.value <= 7 ? :split : :hit
    elsif pair_rank == :four
      upcard.value == 5 || upcard.value == 6 ? :split : :hit
    elsif pair_rank == :five
      upcard.value < 10 ? :double : :stay
    elsif pair_rank == :six
      upcard.value <= 6 ? :split : :stay
    elsif pair_rank == :seven
      upcard.value <= 7 ? :split : :stay
    elsif pair_rank == :nine
      upcard.value <= 9 && upcard.value != 7 ? :split : :stay
    elsif pair_rank == :eight || pair_rank == :ace
      :split
    else
      :stay
    end
  end
end
