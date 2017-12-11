require 'yaml'

class GameStationGames
  GAMES_LIST_FILE = 'games.yml'.freeze
  GAMES_DIR = 'games'.freeze
  GAME_TYPE = :game

  attr_reader :games

  def initialize
    @games = load_games
  end

  def load_games
    games = []
    preload_games = YAML.load_file(GAMES_LIST_FILE)
    preload_games.each do |game|
      next unless game_file_exist?(game[:class])
      require_relative game_path(game[:class])
      game[:item_type] = GAME_TYPE
      games << game
    end

    games
  end

  def game_type
    GAME_TYPE
  end

  private

  def game_file_exist?(game_name)
    File.exist?(game_path(game_name))
  end

  def game_path(game_name)
    game_name = game_name.downcase
    "#{GAMES_DIR}/#{game_name}/#{game_name}.rb"
  end
end
