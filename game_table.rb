require_relative 'human.rb'
require_relative 'computer.rb'
require_relative 'deck.rb'

class GameTable
  attr_reader :players, :bank, :points_to_win, :deck, :value_bet

  def initialize(players, deck)
    @players = players
    @deck = deck
    @points_to_win = 21

    @value_bet = 10    
    @bank = nil
  end
end
