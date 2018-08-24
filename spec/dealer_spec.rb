require 'rspec'
require 'dealer'

describe Dealer do
  let(:dealer) { Dealer.new }
  let(:hand) { double('hand') }
  let(:shoe) { double('shoe') }
  let(:card) { double('card') }

  describe '#initialize' do
    it 'has a hand' do
      expect(dealer.instance_variable_get(:@hand)).to be_a(Hand)
    end
  end

  # describe '#play_hand' do
  #   let(:real_hand) { Hand.new }
  #   before(:each) do
  #     allow(card).to receive(:rank).and_return(:ace)
  #     allow(shoe).to receive(:draw_card).and_return(card)
  #     dealer.instance_variable_set(:@hand, real_hand)
  #   end
  #   it 'adds card to value' do
  #     real_hand.instance_variable_set(:@value, 16)
  #     expect(real_hand).to receive(:add_card_to_value)
  #     dealer.play_hand(shoe)
  #   end
  #   it 'hits up to 16' do
  #     real_hand.instance_variable_set(:@value, 16)
  #     expect(real_hand).to receive(:hit)
  #     dealer.play_hand(shoe)
  #   end
  #   it 'stays on 17' do
  #     real_hand.instance_variable_set(:@value, 17)
  #     expect(real_hand).to_not receive(:hit)
  #     dealer.play_hand(shoe)
  #   end
  # end

  describe '#hit' do
    it 'hits the Dealer\'s hand' do
      dealer.instance_variable_set(:@hand, hand)
      allow(hand).to receive(:hit)
      allow(shoe).to receive(:draw_card).and_return(card)
      allow(card).to receive(:rank).and_return(:ace)
      expect(hand).to receive(:hit)
      dealer.hit(shoe)
    end
  end
end
