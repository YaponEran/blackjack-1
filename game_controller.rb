require 'game_table.rb'

class GameController

  attr_reader :game_tables

  def initialize
    players = [create_human_player, create_computer_player]
    game_tables << GameTable.new(players)
  end

 
  def print_actions
  end
 
  def create_human_player
    Human.new(gets_player_name)
  end
  
  def create_computer_player
    Computer.new
  end

  def gets_player_name
    print "Введите имя: "
    get.chomp
  end
 
end
