require_relative 'game_station_games'
require_relative 'game_station_error'

class GameStationMenu
  EXIT_ACTION = :exit
  MENU_ACTION = [
    {
      item_type: :header,
      name: 'Разное'
    },
    {
      item_type: :action,
      name: 'Статистика',
      method: :print_statistic
    },
    {
      item_type: :action,
      name: 'Выход',
      method: :exit
    }
  ].freeze

  attr_reader :menu, :games

  def initialize
    @menu = MENU_ACTION.dup
    @games = GameStationGames.new
    add_items_to_head(add_header('Список игр', games.games))
  end

  def print_menu
    menu.each_with_index do |item, index|
      case item[:item_type]
      when :header then puts header_text(item[:name])
      else puts "[#{index}] #{item[:name]}"
      end
    end
  end

  def exit_action
    EXIT_ACTION
  end

  private

  def add_header(header, data)
    raise GameStationError, 'Заголовок должен быть String' unless header.is_a?(String)
    raise GameStationError, 'Данные должны быть Array' unless data.is_a?(Array)

    data.unshift(item_type: :header, name: header)
  end

  def add_items_to_head(data)
    raise GameStationError, 'Данные должны быть Array' unless data.is_a?(Array)
    data.reverse.each { |item| menu.unshift(item) }
  end

  def add_items_to_tail(data)
    raise GameStationError, 'Данные должны быть Array' unless data.is_a?(Array)
    data.each { |item| menu.unshift(item) }
  end

  def header_text(text)
    "\n#{text}"
  end
end
