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
    action_result = nil
    loop do
      show_cards if each_player_have_three_cards?
      clear_screen
      puts action_result
      print_players_state
      players.each do |player|
        self.current_player = player
        update_enabled_actions
        action_result = player.computer? ? computer_remote : send(gets_actions)
      end

      break if action_result == :exit
    end
  end

  def prepare_new_game
    players_clear_hand
    create_deck
    give_out_cards(2)
  end

  def players_clear_hand
    players.each(&:clear_hand)
  end

  def create_deck
    self.deck = Deck.new
  end

  def exit
    :exit
  end

  def take_card_allow?
    current_player.cards.length < 3 && current_player.points < 21
  end

  def computer_remote
    take_card_allow? && rand(50) >= 25 ? take_card : pass
  end

  def each_player_have_three_cards?
    have_not_three_cards = players.collect { |player| player.cards.length < 3 }
    have_not_three_cards.empty?
  end

  def take_card
    current_player.take_card(deck.cards.pop)
  end

  def print_players_state
    players_state.each do |player|
      cards = player[:cards].join(' | ')
      puts "#{player[:name]} (#{player[:bank]}): [ #{cards} ] = #{player[:points]}"
    end
  end

  def player_state(player)
    {
      bank:   player.bank,
      name:   player.name,
      cards:  player.cards.collect { |card| player.computer? ? '?' : card },
      points: player.computer? ? '?' : player.points
    }
  end

  def players_state
    players.collect { |player| player_state(player) }
  end

  def show_cards
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

  def pass
    true
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

  def update_enabled_actions
    self.enabled_actions = ACTIONS.select do |action|
      action.key?(:allow) && send(action[:allow]) || !action.key?(:allow)
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

  attr_accessor :current_player, :enabled_actions
  attr_writer :deck
  attr_reader :players_count
end
