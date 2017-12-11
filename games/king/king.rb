class King < Contract::Game
  def self.start(name)
    printf "\n#{name}, это тест ...нажмите любую клавишу...\n"
    gets
  end
end
