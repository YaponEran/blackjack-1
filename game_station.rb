require_relative 'utilities/keyboard_gets.rb'
require_relative 'utilities/screen.rb'
require_relative 'game_station_error.rb'
require_relative 'game_station_games.rb'
require_relative 'game_station_menu.rb'
require_relative 'validation.rb'
require_relative 'user.rb'

class GameStation
  include Validation
  include KeyboardGets

  attr_reader :menu, :user

  validate :user, :type, User

  def initialize
    @user = sign_in
    @menu = GameStationMenu.new
    validate!
  rescue ValidationError => errors
    raise GameStationError, errors
  end

  def change_item
    number = gets_integer("\nВыберите действие: ")
    raise StandardError, "Действие не найдено (#{number})" if menu.menu[number].nil?

    if item_game?(menu.menu[number])
      start_game(game: menu.menu[number], user: user)
    else
      self.send menu.menu[number][:method] unless menu.menu[number][:method].nil?
    end

    menu.menu[number]
  end

  def print_statistic
    Screen.clear
    user.print_games_history
    gets
  end

  def print_menu
    print_top_bar
    menu.print_menu
    change_item
  rescue StandardError => error
    raise GameStationError, error
  end

  def item_game?(item)
    item[:item_type] == menu.games.game_type
  end

  private

  def sign_in
    User.new(gets_user_name)
  end

  def print_top_bar
    if user.games_history.nil?
      games_exec_count = 0
    else
      games_exec_count = user.games_history.length
    end
    puts "Пользователь: #{user.name} | Игр открыто: #{games_exec_count}"
  end

  def gets_user_name
    gets_string('Введите имя: ')
  end

  def start_game(params)
    Object.const_get(params[:game][:class]).start(params[:user].name)
  rescue StandardError => error
    raise GameSationError, "Игра не может быть запущена (#{params[:game][:name]}): #{error}"
  end
end
