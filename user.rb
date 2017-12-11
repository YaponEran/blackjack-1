require_relative 'validation.rb'
require_relative 'accessors.rb'

class User
  include Validation
  include Accessors

  attr_accessor_with_history :games
  attr_reader :name
  attr_accessor :player

  NAME_FORMAT = /^[a-z0-9_]+$/i

  validate :name, :type, String
  validate :name, :min_length, 3
  validate :name, :max_length, 15
  validate :name, :format, NAME_FORMAT, message: 'Имя может включать только a-z, 0-9 и _'

  def initialize(name)
    @name = name
    validate!
  end

  def print_games_history
    raise StandardError, 'История игр пуста' if games_history.nil?
    games_history.each_pair do |name, stat|
      puts "#{name}\n  кол-во запусков: #{stat[:count]}"
      puts "  первый запуск: #{time_norm_format(stat[:first_exec])}"
      puts "  последний запуск: #{time_norm_format(stat[:last_exec])}"
      puts
    end
  end

  private

  def time_norm_format(time)
    time.strftime '%H:%M %d-%m-%Y'
  end
end
