defmodule DailyFantasy.Lineups.Lineup.FanduelNFL do
  @moduledoc """
  Defines an NFL lineup and provided related functions.
  """

  require Logger
  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players.Player

  defstruct\
    qb: struct(Player),\
    rb: [struct(Player), struct(Player)],\
    wr: [struct(Player), struct(Player), struct(Player)],\
    te: struct(Player),\
    k: struct(Player),\
    d: struct(Player),\
    total_salary: nil,\
    total_points: nil

  @doc """
  Construct a map of players for each position.
  """
  def map_positions do
    players = PlayerRegistry.get_essentials

    %{:qb => Lineup.map_position(players, :QB, 1),
      :rb => Lineup.map_position(players, :RB, 2),
      :wr => Lineup.map_position(players, :WR, 3),
      :te => Lineup.map_position(players, :TE, 1),
      :k  => Lineup.map_position(players, :K, 1),
      :d  => Lineup.map_position(players, :D, 1)}
  end

  @doc """
  Create lineup combinations by creating every
  possible combination of players.
  """
  def possible_lineups(data) do
    Logger.info "Creating lineups"

    for qb <- data[:qb],
        rb <- data[:rb],
        wr <- data[:wr],
        te <- data[:te],
        k  <- data[:k],
        d  <- data[:d],
        lineup <- [qb ++ rb ++ wr ++ te ++ k ++ d],
        Lineup.get_salary(lineup) <= 60_000,
        do: lineup
  end
end
