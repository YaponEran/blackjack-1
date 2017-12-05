require_relative 'deck.rb'
require_relative 'keyboard_gets.rb'
require_relative 'blackjack_player.rb'

class Blackjack < Game
  include KeyboardGets

  POINTS_TO_WIN = 21
  BET_VALUE = 10
  ACTIONS = [
    {
      action: :pass,
      name: 'Пасс'
    },
    {
      action: :take_card,
      name: 'Взять карту',
      allow: :take_card_allow?
    },
    {
      action: :show_cards,
      name: 'Раскрыть карты'
    },
    {
      action: :exit,
      name: 'Выйти в меню'
    }
  ].freeze

  attr_reader :players, :deck, :bank

  def initialize(players)
    @players = players
    @bank = 0
    @players_count = players.length
    
  end

  def self.start(user_name, bot_count = 1)
    players = [BlackjackPlayer.new(user_name)]
    bot_count.times { players << BlackjackPlayer.create_bot }

    new(players).game
  end

  def game
    prepare_new_game
    action = nil
    loop do
      show_cards if each_player_have_three_cards?
      clear_screen
      print_players_state

      players.each do |player|
        self.current_player = player
        update_enabled_actions(player)
        
        action = gets_actions
        break if action == :exit
        player.computer? ? computer_remote(player) : send(action, player)
      end

      break if action == :exit
    end
  end

  def prepare_new_game
    players_clear_hand
    create_deck
    give_out_cards(2)
    show_hand = false
  end

  def players_clear_hand
    players.each(&:clear_hand)
  end

  def create_deck
    self.deck = Deck.new
  end

  def take_card_allow?(player)
    player.cards.length < 3 && player.points < 21
  end

  def computer_remote(player)
    take_card_allow?(player) && rand(50) >= 25 ? take_card(player) : pass(player)
  end

  def each_player_have_three_cards?
    have_not_three_cards = players.collect { |player| player.cards.length < 3 }
    have_not_three_cards.empty?
  end

  def take_card(player)
    player.take_card(deck.cards.pop)
  end

  def print_players_state
    players.each do |player|
      puts player.state(hide_hand: hide_hand?)
    end
  end

  def show_hand?
    show_hand
  end
 
  def hide_hand?
    !show_hand?
  end

  def players_state
    players.collect { |player| player_state(player) }
  end

  def show_cards(player)
    self.show_hand = true
    clear_screen
    print_players_state
    print_winner(winner)
    gets
  end

  def print_winner(player)
    puts player.nil? ? 'Нет победителей' : "Победил #{player.name}"
  end

  def winner
    winner = players.first
    players.each do |player|
      if player.points > winner.points && player.points <= POINTS_TO_WIN
        winner = player
      end
    end

    winner.points <= POINTS_TO_WIN ? winner : nil
  end

  def pass(player)
    player.pass
  end

  def clear_screen
    print "\e[2J\e[f"
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

  def give_out_cards(n = 1)
    players.each do |player|
      n.times { player.take_card(deck.cards.pop) }
    end
  end

  def update_enabled_actions(player)
    self.enabled_actions = ACTIONS.select do |action|
      action.key?(:allow) && send(action[:allow], player) || !action.key?(:allow)
    end
  end

  def gets_actions
    print_actions
    number = gets_integer('Выберите действие: ')
    raise StandardError, "Действие неопознано: #{number}" if ACTIONS[number].nil?

    enabled_actions[number][:action]
  end

  def print_actions
    enabled_actions.each_with_index do |action, index|
      puts "[#{index}] #{action[:name]}"
    end
  end

  protected

  attr_accessor :current_player, :enabled_actions, :show_hand
  attr_writer :deck
  attr_reader :players_count
end
