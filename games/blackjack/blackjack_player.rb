require_relative 'name_generator.rb'

class BlackjackPlayer < Player
  extend NameGenerator

  attr_reader :bank, :cards, :computer

  def initialize(name, computer = false, dealer = false)
    @bank = 100
    @dealer = dealer
    @cards = []
    super(name, computer)
  end

  def take_card(card)
    cards << card
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

  def calculate_points
    points = 0
    cards.each { |card| points += card.value }

    points
  end

  def self.create_bot
    new(generate_name, true, true)
  end

  protected

  attr_reader :dealer
end
