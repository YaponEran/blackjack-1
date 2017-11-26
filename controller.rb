require 'yaml'

require_relative  'blackjack.rb'
require_relative  'computer.rb'
require_relative  'human.rb'
require_relative  'keyboard_gets.rb'

class Controller

  include KeyboardGets

  GAMES_LIST_FILE = 'games.yml'.freeze

  attr_reader :games

  def initialize
    @player = create_player_human
    @games = load_games_list
  end

  def change_game
    print_games
    number = gets_integer("Выберите номер игры: ")
    raise StandardError, "Номер игры не найден: #{number}" if games[number].nil?

    start_game({game: games[number], player: player})
  end
 
  private

  attr_reader :player

  def create_player_human
    Human.new(gets_player_name)
  end

  def gets_player_name
    gets_string("Введите имя: ")
  end 

  def create_deck
    Deck.new
  end

  def create_player_computer
    Computer.new
  end

  def print_games
    puts 'Список игр:'
    games.each_with_index { |game, index| puts "[#{index}] #{game[:name]}" }
  end

  def load_games_list
    @games = YAML.load_file(GAMES_LIST_FILE)
  end

  def start_game(params)
    case params[:game][:class]
    when 'Blackjack'
      game = Blackjack.new([params[:player], create_player_computer])
    end

    game.run
  end
end
