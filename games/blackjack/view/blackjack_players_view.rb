class BlackjackPlayersView
  attr_reader :players

  def initialize(players)
    @players = players
  end

  def print_players_state(params)
    params[:l_column_length] = [players_max_name.length, players_max_face.length].max
    players.each do |player|
      print_player_state(player, params)
      printf "\n\n"
    end
  end

  private

  def players_max_name
    players.max_by { |player| player.name.length }.name
  end

  def players_max_face
    players.max_by { |player| player.face.length }.face
  end

  def print_player_state(player, params)
    l_column_length = params[:l_column_length] || [player.face.length, player.name.length].max

    state = player.state
    printf "%-#{l_column_length}s | %s | %s\n", player.face, state[:cards], state[:points]
    printf "%-#{l_column_length}s | %s", player.name, "#{player.cash}$"
  end
end
