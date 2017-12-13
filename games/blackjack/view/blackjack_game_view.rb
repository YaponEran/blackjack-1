class BlackjackGameView
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def print_game_state
    puts ["[Раунд #{game.round_number}]",
          "Банк игры #{game.bank}",
          "Ставка #{game.bet_rate}$",
          "Игроков #{game.players.length}"].join(' | ')
  end

  def print_actions
    puts '[Действия]'
    game.allowed_actions.each_with_index do |action, index|
      puts '---' if action[:separate]
      puts "[#{index}] #{action[:name]}"
    end
  end
end
