class User
  attr_reader :name
  attr_accessor :player

  def initialize(name)
    @name = name
  end
end
