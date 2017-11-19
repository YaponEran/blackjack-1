require_relative 'human.rb'
require_relative 'computer.rb'
require_relative 'deck.rb'

class GameTable
  attr_reader :players, :bank, :points_to_win, :deck, :value_bet

  def initialize(players, deck)
    cards_start_count = 2

    @players = players
    @deck = deck
    @points_to_win = 21

    give_out_cards(cards_start_count)

    @value_bet = 10    
    @bank = nil
  end

  private
  
  def give_out_cards(n)
    players.each do |player|
      n.times do |_|
        player.add_card(deck)
      end
    end    
  end
end

p1 = Computer.new
p2 = Human.new('Alex')
d = Deck.new

gt = GameTable.new([p1,p2], d)
