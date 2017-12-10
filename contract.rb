require_relative 'validation.rb'

module Contract
  class Game
    attr_reader :players

    def self.start(user_name)
    end
  end

  class Player
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end
