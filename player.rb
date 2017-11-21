class Player
  attr_reader :bank, :name, :cards

  def initialize(name, dealer = false)
    @name = name
    @bank = 100
    @dealer = dealer
    @cards = []
  end

  def add_card(deck)
    cards << deck.cards.pop
  end

  def pass
    #пропустить ход
  end

  def dealer?
    dealer
  end

  def place_bet(bet_value)
    self.bank -= bet_value
  end

  protected

  attr_reader :dealer

end
