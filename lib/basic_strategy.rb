module BasicStrategy
  module_function

  def action(hand, upcard)
    if pair?(hand)
      action_with_pair(hand, upcard)
    elsif soft?
      action_with_soft_hand(hand, upcard)
    else
      action_with_hard_hand(hand, upcard)
    end
  end

  def pair?(hand)
    return false unless hand.cards.length == 2
    hand.cards.first.rank == hand.cards.last.rank
  end

  def soft?(hand)
    !hand.hard && hand.cards.any? { |card| card.rank == :ace }
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

  def action_with_soft_hand(hand, upcard)
    case hand.value
    when 13, 14
      upcard.value < 5 || upcard.value > 6 ? :hit : :double
    when 15, 16
      upcard.value < 4 || upcard.value > 6 ? :hit : :double
    when 17
      upcard.value < 3 || upcard.value > 6 ? :hit : :double
    when 18
      action_with_soft_18(hand, upcard)
    else
      :stay
    end
  end

  def action_with_hard_hand(hand, upcard)
    case hand.value
    when 5, 6, 7, 8
      :hit
    when 9
      upcard.value < 3 || upcard.value > 6 ? :hit : :double
    when 10
      upcard.value < 10 ? :double : :hit
    when 11
      upcard.value < 11 ? :double : :hit
    when 12
      upcard.value <= 3 ? :hit : :stay
    when 13, 14, 15, 16
      upcard.value >= 7 ? :hit : :stay
    else
      :stay
    end
  end

  def action_with_soft_18(hand, upcard)
    if [2, 7, 8].include?(upcard.value)
      :stay
    elsif upcard.value < 7
      :double
    else
      :stay
    end
  end
end
