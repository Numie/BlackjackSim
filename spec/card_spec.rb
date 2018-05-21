require 'rspec'
require 'card'

describe Card do
  let(:ace) { Card.new(:ace, :spades) }
  let(:jack_hearts) { Card.new(:jack, :hearts) }
  let(:jack_diamonds) { Card.new(:jack, :diamonds) }
  let(:eight) { Card.new(:eight, :clubs) }

  describe '::suits' do
    it 'includes all of the suits' do
      expect(Card.suits).to eq([:ace, :diamonds, :spades, :clubs])
    end
  end

  describe '::ranks' do
    it 'includes all of the ranks' do
      expect(Card.ranks).to eq([:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two])
    end
  end

  describe '#initialize' do
    it 'has a rank and a suit' do
      expect(ace.instance_variables).to include(:rank)
      expect(ace.instance_variables).to include(:suit)
    end
  end

  describe '#to_s' do
    it 'prints the card' do
      expect(ace.to_s).to eq('ace of spades')
    end
  end

  describe '#value' do
    context 'when a card is an Ace' do
      it 'returns 11' do
        expect(ace.value).to eq(11)
      end
    end

    context 'when the card is a face' do
      it 'returns 10' do
        expect(jack_hearts.value).to eq(10)
      end
    end

    context 'when the card is not an Ace or a face' do
      it 'returns the card\'s value' do
        expect(eight.value).to eq(8)
      end
    end
  end
end
