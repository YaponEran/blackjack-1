require_relative 'deck.rb'
require_relative 'keyboard_gets.rb'
require_relative 'blackjack_player.rb'

class Blackjack < Game
  include KeyboardGets

  POINT_TO_WIN = 21
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
    @deck = Deck.new
    @bank = 0
    @players_count = players.length
    give_out_cards(2)
  end

  def self.start(user_name, bot_count = 1)
    players = [BlackjackPlayer.new(user_name)]
    bot_count.times { players << BlackjackPlayer.create_bot }

    new(players).game
  end

  def game
    loop do
      show_cards if each_player_have_three_cards?
      self.current_player = next_player
      update_enabled_actions
      if current_player.computer?
        turn_result = "#{current_player.name}: #{computer_remote(current_player)}"
      else
        clear_screen
        puts turn_result.to_s if turn_result
        print_state(current_player)

        break if send(gets_actions) == :exit
      end
    end
  end

  def exit
    :exit
  end

  def take_card_allow?
    current_player.cards.length < 3
  end

  def computer_remote(player)
    if player.calculate_points < 18 && take_card_allow?
      take_card
      'взял карту..'
    else
      pass
      'я пасс..'
    end
  end

  def each_player_have_three_cards?
    have_not_three_cards = players.collect { |player| player.cards.length < 3 }
    have_not_three_cards.empty?
  end

  def take_card
    card_to_player(current_player)
  end

  def print_state(player)
    puts '---'
    puts "Игрок: #{player.name}"
    puts "Рука: #{player.cards.join(' | ')}"
    puts "Очков: #{player.calculate_points}"
    puts '---'
  end

  def player_state(player)
    {
      name:   player.name,
      cards:  player.cards,
      points: player.calculate_points
    }
  end

  def players_state
    players.collect { |player| player_state(player) }
  end

  def show_cards
    clear_screen
    players_state.each do |player|
      puts "#{player[:name]}: #{player[:points]} [ #{player[:cards].join(' | ')} ]"
    end
    puts '---'
    print_winner(winner)
    gets
  end

  def print_winner(player)
    puts "Победил #{player.name}!"
  end

  def winner
    winner = players.first
    players.each do |player|
      winner = player if player.calculate_points > winner.calculate_points
    end

    winner
  end

  def pass
    true
  end

  def clear_screen
    print "\e[2J\e[f"
  end

  def next_player
    if current_player.nil?
      number = 0
    else
      number = player_number(current_player) + 1
      number = 0 if number > players.length - 1
    end

    players[number]
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

  def card_to_player(player)
    player.take_card(deck.cards.pop)
  end

  def give_out_cards(n = 1)
    players.each do |player|
      n.times { card_to_player(player) }
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
  attr_reader :players_count
end
