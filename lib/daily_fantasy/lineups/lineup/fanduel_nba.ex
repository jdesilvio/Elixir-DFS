defmodule DailyFantasy.Lineups.Lineup.FanduelNBA do
  @moduledoc """
  Defines an NBA lineup and provided related functions.
  """

  require Logger
  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players.Player

  defstruct\
    pg: [struct(Player), struct(Player)],\
    sg: [struct(Player), struct(Player)],\
    sf: [struct(Player), struct(Player)],\
    pf: [struct(Player), struct(Player)],\
    c: struct(Player),\
    total_salary: nil,\
    total_points: nil

  @doc """
  Construct a map of players for each position.
  """
  def map_positions do
    players = PlayerRegistry.get_essentials

    %{:pg => Lineup.map_position(players, :PG, 2),
      :sg => Lineup.map_position(players, :SG, 2),
      :sf => Lineup.map_position(players, :SF, 2),
      :pf => Lineup.map_position(players, :PF, 2),
      :c  => Lineup.map_position(players, :C, 1)}
  end

  @doc """
  Create lineup combinations by creating every
  possible combination of players.
  """
  def possible_lineups(data) do
    Logger.info "Creating lineups"

    for pg <- data[:pg],
        sg <- data[:sg],
        sf <- data[:sf],
        pf <- data[:pf],
        c  <- data[:c],
        lineup <- [pg ++ sg ++ sf ++ pf ++ c],
        Lineup.get_salary(lineup) <= 60_000,
        do: lineup
  end
end
