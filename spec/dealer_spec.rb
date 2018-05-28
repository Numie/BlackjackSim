require 'rspec'
require 'dealer'

describe Dealer do
  let(:dealer) { Dealer.new }

  describe '#initialize' do
    it 'has a hand' do
      expect(dealer.instance_variable_get(:@hand)).to be_a(Hand)
    end
  end
end
