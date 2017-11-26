require_relative 'keyboard_gets.rb'
require_relative 'deck.rb'

class Blackjack

  include KeyboardGets

  POINT_TO_WIN = 21.freeze
  BET_VALUE = 10.freeze
  ACTIONS = [
    {
      action: :pass,
      name: "Пасс"
    },
    {
      action: :take_card,
      name: "Взять карту"
    },
    {
      action: :show_cards,
      name: "Раскрыть карты"
    },
  ].freeze

  attr_reader :players, :deck, :bank

  def initialize(players)
    @players = players
    @deck = Deck.new
    @bank = 0
    @players_count = players.length
    give_out_cards(2)
  end

  def run
    next_player
    loop do
      clear_screen
      print_state
      puts "---"
      self.send gets_actions
      next_player
    end
  end

  def take_card
    give_out_card(current_player)
  end

  def print_state
    puts "Игрок: #{current_player.name}"
    puts "Рука: #{current_player.cards.join(' | ')}"
    puts "Очков: #{current_player.calculate_points}"
  end

  def show_cards
    #подсчёт очков
  end

  def pass
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def next_player
    if self.current_player.nil?
      number = 0
    else
      number = player_number(current_player) + 1
      number = 0 if number > players.length - 1
    end

    self.current_player = players[number]
  end

  def player_number(player)
    players.find_index(player)
  end

  def game_bank_to_player_bank(player)
    player.bank += bank 
    self.bank = 0
  end

  def player_bet_to_bank(player)
    player.bank -= BET_VALUE
    self.bank += BET_VALUE
  end

  def players_bet_to_bank
    players.each { |player| player_bet_to_bank(player) }
  end

  def give_out_card(player)
    player.take_card(deck)
  end

  def give_out_cards(n=1)
    players.each do |player|
      n.times { give_out_card(player) }
    end
  end
  
  def gets_actions
    print_actions
    number = gets_integer("Выберите действие: ")
    raise StandardError, "Действие неопознано: #{number}" if ACTIONS[number].nil?
    
    ACTIONS[number][:action]
  end  
  
  def print_actions
    ACTIONS.each_with_index do |action, index|
      puts "[#{index}] #{action[:name]}"
    end
  end

  protected
  
  attr_accessor :current_player
  attr_reader :players_count
end









