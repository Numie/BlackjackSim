require 'rspec'
require 'shoe'

describe Shoe do
  let(:shoe) { Shoe.new }

  describe '::create_shoe' do
    let(:new_shoe) { Shoe.create_shoe }
    it 'creates an eight deck shoe' do
      expect(new_shoe.length).to eq(416)
    end
    it 'has the correct number of each suit' do
      expect(new_shoe.count { |card| card.suit == :hearts }).to eq(104)
      expect(new_shoe.count { |card| card.suit == :diamonds }).to eq(104)
      expect(new_shoe.count { |card| card.suit == :spades }).to eq(104)
      expect(new_shoe.count { |card| card.suit == :clubs }).to eq(104)
    end
    it 'is shuffled' do
      10.times do
        newer_shoe = Shoe.create_shoe
        expect(new_shoe).to_not eq(newer_shoe)
      end
    end
  end

  describe '#initialize' do
    let(:cards) { shoe.cards }
    it 'has an array of cards' do
      expect(cards).to be_an(Array)
    end
    it 'has the correct number of cards' do
      expect(cards.length).to eq(416)
    end
  end

  describe '#draw_card' do
    it 'removes a card from the shoe' do
      card = shoe.draw_card
      expect(shoe.cards.length).to eq(415)
    end
    it 'returns the drawn card' do
      card = shoe.draw_card
      expect(card).to be_a(Card)
    end
  end

  describe '#count' do
    it 'returns the initial length of the shoe' do
      expect(shoe.count).to eq(416)
    end
    it 'returns the length of the shoe after cards have been drawn' do
      random_num = (1..20).to_a.sample
      random_num.times do
        shoe.draw_card
      end
      expect(shoe.count).to eq(416 - random_num)
    end
  end
end
