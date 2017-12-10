require_relative 'utilities/keyboard_gets.rb'
require_relative 'utilities/screen.rb'
require_relative 'game_station_error.rb'
require_relative 'validation.rb'
require_relative 'user.rb'
require 'yaml'

class GameStation
  include Validation
  include KeyboardGets

  GAMES_LIST_FILE = 'games.yml'.freeze
  GAMES_DIR = 'games'.freeze

  attr_reader :games, :user

  validate :user, :type, User
  validate :games, :type, Array

  def initialize
    @user = sign_in
    @games = load_games
    validate!
  rescue ValidationError => errors
    raise GameStationError, errors
  end

  def change_game
    number = gets_integer('Выберите номер игры: ')
    raise StandardError, "Номер игры не найден (#{number})" if games[number].nil?

    start_game(game: games[number], user: user)
  rescue StandardError => error
    raise GameStationError, error
  end

  def print_menu
    print_user_info
    puts 
    print_games
    change_game
  end

  private

  def sign_in
    User.new(gets_user_name)
  end

  def load_games
    games = []
    preload_games = YAML.load_file(GAMES_LIST_FILE)
    preload_games.each do |game|
      if game_file_exist?(game[:class])
        require_relative game_path(game[:class])
        games << game
      end
    end
    
    games
  end

  def print_user_info
    puts "Пользователь: #{user.name}"
  end

  def game_file_exist?(game_name)
    File.exist?(game_path(game_name))
  end

  def game_path(game_name)
    game_name = game_name.downcase
    "#{GAMES_DIR}/#{game_name}/#{game_name}.rb"
  end

  def gets_user_name
    gets_string('Введите имя: ')
  end

  def print_games
    puts 'Список игр:'
    games.each_with_index { |game, index| puts "[#{index}] #{game[:class]}" }
  end

  def start_game(params)
    Object.const_get(params[:game][:class]).start(params[:user].name)
  rescue StandardError => error
    raise GameSationError, "Игра не может быть запущена (#{params[:game][:name]}): #{error}"
  end
end
