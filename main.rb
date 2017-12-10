require_relative 'contract.rb'
require_relative 'validation.rb'
require_relative 'game_station.rb'
require_relative 'utilities/screen.rb'

game_station = nil

def print_error(error)
  Screen::clear
  puts "Ошибка: #{error}\n\n...нажмите любую клавишу..."
  gets 
end


loop do
  begin
    Screen::clear
    game_station ||= GameStation.new
    Screen::clear
    game_station.print_menu
  rescue GameStationError => error
    print_error(error)
  end
end

