require_relative 'game_station.rb'

game_station = GameStation.new

loop do
  begin
    game_station.change_game
  rescue StandardError => error
    puts "Ошибка: #{error}"
  end
end
