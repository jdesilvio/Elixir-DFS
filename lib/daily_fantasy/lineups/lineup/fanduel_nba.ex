defmodule DailyFantasy.Lineups.Lineup.FanduelNFL do
  @moduledoc """
  Defines an NFL lineup and provided related functions.
  """

  alias DailyFantasy.Players.Player
  alias DailyFantasy.Players

  defstruct\
    pg: [struct(Player), struct(Player)],\
    sg: [struct(Player), struct(Player)],\
    sf: [struct(Player), struct(Player)],\
    pf: [struct(Player), struct(Player)],\
    c: struct(Player),\
    total_salary: nil,\
    total_points: nil

  @doc """
  Construct a map of position maps.

  Filters on a point threshold and maps players to appropriate position.
  Creates combinations for positions requiring multiple players (RB and WR).

  Returns a map for each position.
  """
  def map_positions(data) do
    %{:pg => data |> Players.filter(0, "PG") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :sg => data |> Players.filter(0, "SG") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :sf => data |> Players.filter(0, "SF") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :pf => data |> Players.filter(0, "PF") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :c  => data |> Players.filter(0, "C")  |> Enum.to_list}
  end

  @doc """
  Create lineup combinations by creating every possible combination
  of players.
  """
  def possible_lineups(data) do
    for pg <- data[:pg],
        sg <- data[:sg],
        wr <- data[:sf],
        te <- data[:pf],
        k  <- data[:c],
        Players.agg_salary([pg, sg, sf, pf, c], 0) <= 60_000 do
          [pg, sg, sf, pf, c]
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
