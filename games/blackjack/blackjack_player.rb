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
    update_points
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

  def pass
    true
  end

  def state(params)
    cards = self.cards.collect { |card| computer? && params[:hide_hand] ? '?' : card }.join(' | ')
    points = computer? && params[:hide_hand] ? '?' : self.points
    "#{name}: [Банк #{bank}] [Рука #{cards}] [Очков #{points}]"
  end

  def computer?
    computer
  end

  def self.create_bot
    new(generate_name, true, true)
  end

  protected

  def update_points
    a = []
    self.points = 0
    cards.each do |card|
      if card.rank == 'A'
        a << card
      else
        self.points += card.value
      end
    end

    a.each do |card|
      self.points += (card.value + points > 21) ? 1 : card.value
    end
  end

  attr_writer :points, :cards
  attr_reader :dealer
end
