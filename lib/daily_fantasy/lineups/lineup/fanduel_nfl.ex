defmodule DailyFantasy.Lineups.Lineup.FanduelNFL do
  @moduledoc """
  Defines an NFL lineup and provided related functions.
  """

  alias DailyFantasy.Players.Player
  alias DailyFantasy.Players

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
  Construct a map of position maps.

  Filters on a point threshold and maps players to appropriate position.
  Creates combinations for positions requiring multiple players (RB and WR).

  Returns a map for each position.
  """
  def map_positions(data) do
    %{:qb => data |> Players.filter(0, "QB") |> Enum.to_list,
      :rb => data |> Players.filter(0, "RB") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :wr => data |> Players.filter(0, "WR") |> Enum.to_list
                  |> Combination.combine(3)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :te => data |> Players.filter(0, "TE") |> Enum.to_list,
      :k  => data |> Players.filter(0, "K")  |> Enum.to_list,
      :d  => data |> Players.filter(0, "D")  |> Enum.to_list}
  end

  @doc """
  Create lineup combinations by creating every possible combination
  of players.
  """
  def possible_lineups(data) do
    for qb <- data[:qb],
        rb <- data[:rb],
        wr <- data[:wr],
        te <- data[:te],
        k  <- data[:k],
        d  <- data[:d],
        Players.agg_salary([qb, rb, wr, te, k, d], 0) <= 60_000 do
          [qb, rb, wr, te, k, d]
        end
  end

  # TODO: Implement a more generic and readable way to sanity check the lineup combos
  @doc """
  Create all possible lineups.

  Executes a series of steps:

    * Imports player data from a file
    * Restructures player data
    * Creates maps for each position and filters by projected points
    * Creates all possible lineup combinations
    * Filter for salary cap ($60,000)
    * Create lineup details with lineup, salary and total points

  """
  def create_lineups(file) do
    DailyFantasy.import_players(file)
    |> Enum.map(&Player.create/1)
    |> map_positions
    |> DailyFantasy.lineup_combinations_check(30_000_000)
  end

end
