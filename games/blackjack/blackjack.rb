require_relative 'deck.rb'
require_relative 'keyboard_gets.rb'
require_relative 'blackjack_player.rb'

class Blackjack < Game
  include KeyboardGets

  POINTS_TO_WIN = 21
  MAX_CARDS = 3
  BET_VALUE = 10

  EXIT_ACTION = :exit
  PLAY_AGAIN_ACTION = :play_again

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
      action: EXIT_ACTION,
      name: 'Выйти в меню',
      separate: true
    }
  ].freeze

  attr_reader :players, :deck, :bank

  def initialize(players)
    @players = players
    @bank = 0
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
      show_cards(players) if each_player_have_three_cards?
      print_states

      players.each do |player|
        if player.computer?
          computer_turn(player)
        else
          action = gets_action(player)
          send action, player unless action == EXIT_ACTION
        end
        break if action == EXIT_ACTION
      end

      break if action == EXIT_ACTION
    end
  end

  def prepare_new_game
    players_clear_hand
    create_deck
    players_bet_to_bank
    give_out_cards(2)
    self.hide_hand = true
    self.round_number = round_number.nil? ? 1 : round_number + 1
  end

  def show_cards(_p)
    self.hide_hand = false
    clear_screen
    winner = winner_player
    game_bank_to_player_bank(winner) if winner
    print_states
    print_winner(winner)
    prepare_new_game if play_again?
  end

  def play_again?
    gets_string('Играть новый раунд? [y/*]: ').downcase == 'y'
  end

  def print_states
    clear_screen
    print_game_state
    puts
    print_players_state
  end

  def print_game_state
    puts "Банк: #{bank} | Игроков: #{players.length} | Раунд: #{round_number}"
  end

  def players_clear_hand
    players.each(&:clear_hand)
  end

  def create_deck
    self.deck = Deck.new
  end

  def take_card_allow?(player)
    player.cards.length < MAX_CARDS && player.points < POINTS_TO_WIN
  end

  def player_turn(player)
    # Хммм... а почему бы и нет?
  end

  def computer_turn(player)
    if take_card_allow?(player)
      risk_points = 17
      case player.points
      when player.points > risk_points then take_card(player) if flip_coint(rand(2))
      else take_card(player)
      end
    else
      pass(player)
    end
  end

  def flip_coint(x)
    rand(2) == x
  end

  def each_player_have_three_cards?
    have_not_three_cards = players.select { |player| player.cards.length < MAX_CARDS }
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

  def hide_hand?
    hide_hand
  end

  def print_winner(player)
    puts player.nil? ? 'Нет победителей' : "Победил #{player.name}"
  end

  def winner_player
    pretendents = players.select { |player| player.points <= POINTS_TO_WIN }
    return nil if pretendents.empty?

    max_points = pretendents.max_by(&:points).points
    winners = pretendents.select { |player| player.points == max_points }

    winners.length > 1 ? nil : winners.first
  end

  def pass(player)
    player.pass
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def game_bank_to_player_bank(player)
    player.get_bank(bank)
    self.bank = 0
  end

  def player_bet_to_bank(player)
    player.place_bet(BET_VALUE)
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

  def update_allowed_actions(player)
    self.allowed_actions = ACTIONS.select do |action|
      action.key?(:allow) && send(action[:allow], player) || !action.key?(:allow)
    end
  end

  def gets_action(player)
    update_allowed_actions(player)
    print_actions
    number = gets_integer('Выберите действие: ')
    raise StandardError, "Действие неопознано: #{number}" if ACTIONS[number].nil?

    allowed_actions[number][:action]
  end

  def print_actions
    puts "\nВаш ход: "
    allowed_actions.each_with_index do |action, index|
      puts '---' if action[:separate]
      puts "[#{index}] #{action[:name]}"
    end
  end

  protected

  attr_accessor :allowed_actions, :hide_hand, :round_number
  attr_writer :deck, :bank
  attr_reader :players_count
end
