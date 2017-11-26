class Player
  attr_reader :bank, :name, :cards

  def initialize(name, dealer = false)
    @name = name
    @bank = 100
    @dealer = dealer
    @cards = []
  end

  def take_card(deck)
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

  def calculate_points
    points = 0
    cards.each { |card| points += card.value }

    points
  end

  protected

  attr_reader :dealer

end
