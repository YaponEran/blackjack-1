class Player
  attr_reader :bank, :name, :cards

  def initialize(name, dealer = false)
    @name = name
    @bank = 100
    @dealer = dealer
    @cards = []
  end

  def add_card(deck)
    cards << deck.pop
  end

  def pass
    #пропустить ход
  end

  def dealer?
    dealer
  end

  protected

  attr_reader :dealer

  def place_bet
    #сделать ставку
  end
end
