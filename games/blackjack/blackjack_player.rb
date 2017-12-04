require_relative 'name_generator.rb'

class BlackjackPlayer < Player
  extend NameGenerator

  attr_reader :bank, :cards, :computer, :points

  def initialize(name, computer = false, dealer = false)
    @bank = 100
    @dealer = dealer
    @cards = []
    @points = 0
    super(name, computer)
  end

  def take_card(card)
    cards << card
    self.points += card.value
  end

  def clear_hand
    self.cards = []
  end

  def dealer?
    dealer
  end

  def place_bet(bet_value)
    self.bank -= bet_value
  end

  def computer?
    computer
  end

  def self.create_bot
    new(generate_name, true, true)
  end

  protected

  attr_writer :points, :cards
  attr_reader :dealer
end
