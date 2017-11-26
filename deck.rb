require_relative 'card.rb'

class Deck
  SUITS = %W[\u2664 \u2661 \u2667 \u2662].freeze
  RANKS = [
    { name: '2', value: 2 }, { name: '3', value: 3 },
    { name: '4', value: 4 }, { name: '5', value: 5 },
    { name: '6', value: 6 }, { name: 'J', value: 7 },
    { name: '6', value: 8 }, { name: '9', value: 9 },
    { name: '10', value: 10 }, { name: 'Q', value: 10 },
    { name: 'K',  value: 10 }, { name: 'A', value: 10 }
  ].freeze

  attr_accessor :cards

  def initialize
    @cards = collect_cards.shuffle
  end

  private

  def collect_cards
    cards = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        cards << Card.new("#{rank[:name]}#{suit}", rank[:value])
      end
    end

    cards
  end
end
