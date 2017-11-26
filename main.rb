require_relative 'controller.rb'

controller = Controller.new

loop do
  controller.change_game
end
