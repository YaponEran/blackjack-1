require_relative 'name_generator.rb'
require_relative 'facer.rb'

class BlackjackPlayer < Contract::Player
  extend NameGenerator
  include Facer

  attr_reader :cash, :cards, :computer, :points, :face
  attr_accessor :hide_cards

  def initialize(name, computer = false, dealer = false)
    @cash = 100
    @dealer = dealer
    @cards = []
    @points = 0
    @face = random_face
    @hide_cards = true
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

  def place_bet(bank)
    raise StandardError unless bank.is_a?(Bank)
    self.cash -= bank.bet_rate
    bank.sum += bank.bet_rate
  end

  def take_bets(bank)
    raise StandardError unless bank.is_a?(Bank)
    self.cash += bank.give_full_sum
  end

  def pass
    true
  end

  def print_state(params = {})
    l_column_length = params[:l_column_length] || [face.length, name.length].max

    printf "%-#{l_column_length}s | %s | %s\n", face, state[:cards], state[:points]
    printf "%-#{l_column_length}s | %s", name, "#{cash}$"
  end

  def state
    {
      cards: cards_state.join(' ').to_s,
      points: points_state.to_s
    }
  end

  def hide_hand
    self.hide_cards = true
  end

  def show_hand
    self.hide_cards = false
  end

  def cards_state
    cards.collect { |card| computer? && hide_cards ? '??' : card }
  end

  def points_state
    computer? && hide_cards ? '??' : points
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
      self.points += card.value + points > 21 ? 1 : card.value
    end
  end

  attr_writer :points, :cards, :cash
  attr_reader :dealer
end
