require_relative 'player'
require_relative 'name_generator'

class Computer < Player
  include NameGenerator

  def initialize
    super(generate_name, true)
  end
end
