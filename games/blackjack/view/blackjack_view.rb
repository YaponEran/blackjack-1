require_relative '../blackjack_error.rb'
require_relative 'blackjack_game_view.rb'
require_relative 'blackjack_players_view.rb'

class BlackjackView
  attr_reader :game, :players

  def initialize(game, players)
    @game =  BlackjackGameView.new(game)
    @players = BlackjackPlayersView.new(players)
  end
end
