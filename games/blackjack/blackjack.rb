require_relative 'deck.rb'
require_relative 'bank.rb'
require_relative 'keyboard_gets.rb'
require_relative 'blackjack_player.rb'
require_relative 'blackjack_error.rb'
require_relative 'view/blackjack_view.rb'

class Blackjack < Contract::Game
  include KeyboardGets

  POINTS_TO_WIN = 21
  START_CARDS = 2
  MAX_CARDS = 3
  BET_RATE = 10

  EXIT_ACTION = :exit
  PLAY_AGAIN_ACTION = :play_again

  ACTIONS = [
    {
      method: :pass,
      name: 'Пасс'
    },
    {
      method: :take_card,
      name: 'Взять карту',
      allow: :take_card_allow?
    },
    {
      method: :show_cards,
      name: 'Раскрыть карты',
      item_type: EXIT_ACTION
    },
    {
      method: :exit_to_menu,
      name: 'Выйти в меню',
      item_type: EXIT_ACTION,
      separate: true
    }
  ].freeze

  attr_reader :players, :deck, :bank, :round_number, :allowed_actions, :viewer

  def initialize(players)
    @players = players
    @bank = Bank.new(BET_RATE)
    @viewer = BlackjackView.new(self)
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
      begin
        print_states
        players.each do |player|
          if player.computer?
            computer_turn(player)
          else
            action = human_turn(player)
          end
        end
        action = show_cards if each_player_have_three_cards?

        prepare_new_game if action == PLAY_AGAIN_ACTION
        break if action == EXIT_ACTION
      rescue BlackjackError => error
        print_error(error)
      end
    end
  end

  def prepare_new_game
    self.round_number = round_number.nil? ? 1 : round_number + 1
    players_place_bet
    players.each(&:clear_hand)
    players.each(&:clear_points)
    create_deck
    give_out_cards(START_CARDS)
    players.each(&:hide_hand)
  end

  def show_cards(_ = nil)
    players.each(&:show_hand)
    clear_screen
    winner = winner_player
    winner.take_bets(bank) if winner
    print_states
    print_winner(winner)
    play_again? ? PLAY_AGAIN_ACTION : EXIT_ACTION
  end

  def play_again?
    gets_string("\nИграть новый раунд? [y/*]: ").downcase == 'y'
  end

  def print_error(error)
    clear_screen
    puts "Ошибка: #{error}"
    press_any_key
  end

  def bet_rate
    BET_RATE
  end

  def print_states
    clear_screen
    viewer.game.print_game_state
    puts
    viewer.players.print_players_state(hide_hand: hide_hand?)
  end

  def players_clear_hand
    players.each(&:clear_hand)
  end

  def exit_to_menu(_)
    EXIT_ACTION
  end

  def create_deck
    self.deck = Deck.new
  end

  def take_card_allow?(player)
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    player.cards.length < MAX_CARDS && player.points < POINTS_TO_WIN
  end

  def human_turn(player)
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    action = gets_action(player)
    return action if action == EXIT_ACTION

    send action, player
  end

  def computer_turn(player)
    raise BlackjackError, 'Ожидайтеся игрок компьютер' unless player.computer?
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
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    player.take_card(deck.cards.pop)
  end

  def hide_hand?
    hide_hand
  end

  def print_winner(player)
    puts player.nil? ? 'Нет победителей' : "Победил #{player.face} #{player.name}"
  end

  def winner_player
    pretendents = players.select { |player| player.points <= POINTS_TO_WIN }
    return nil if pretendents.empty?

    max_points = pretendents.max_by(&:points).points
    winners = pretendents.select { |player| player.points == max_points }

    winners.length > 1 ? nil : winners.first
  end

  def pass(player)
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    player.pass
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def players_place_bet
    players.each { |player| player.place_bet(bank) }
  end

  def give_out_cards(n = 1)
    players.each do |player|
      n.times { player.take_card(deck.cards.pop) }
    end
  end

  def update_allowed_actions(player)
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    self.allowed_actions = ACTIONS.select do |action|
      action.key?(:allow) && send(action[:allow], player) || !action.key?(:allow)
    end
  end

  def gets_action(player)
    raise BlackjackError, 'Ожидается тип BlackjackPlayer' unless player.is_a?(BlackjackPlayer)
    update_allowed_actions(player)
    viewer.game.print_actions
    number = gets_integer("\nВаш ход: ")
    raise BlackjackError, "Действие неопознано: #{number}" if ACTIONS[number].nil?

    allowed_actions[number][:method]
  end

  def press_any_key
    puts "\n...нажмите любую клавишу..."
    gets
  end

  protected

  attr_accessor :hide_hand
  attr_writer :deck, :bets, :round_number, :allowed_actions
end
