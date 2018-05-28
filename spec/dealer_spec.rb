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
