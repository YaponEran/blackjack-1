class Player
  attr_reader :name, :computer

  def initialize(name, computer = false)
    @name = name
    @computer = computer
  end

end
