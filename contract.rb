module Contract
  class Game
    attr_reader :players

    def self.start(user_name)
    end
  end

  class Player
    attr_reader :name, :computer
    
    def initialize(name, computer = false)
      @name = name
      @computer = computer
    end
  end
end
