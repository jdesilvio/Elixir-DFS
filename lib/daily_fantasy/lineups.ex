defmodule DailyFantasy.Lineups do
  @moduledoc """
  Functions related to lineups, i.e. a collection of %Lineup{} structs.
  """

  alias DailyFantasy.Players.Player
  alias DailyFantasy.Lineups.Lineup.FanduelNFL

  @doc """
  Calculates the total number of possible lineups using the number
  of imported players.

  Input a map of players sorted into positions.

  Returns an integer.
  """
  def lineup_combinations(position_map) do
    for keys <- Map.keys(position_map) do
      Enum.count(position_map[keys])
    end
    |> Enum.reduce(&(&1 * &2))
  end

  @doc """
  Create all possible lineups.

  Executes a series of steps:

    * Imports player data from a file
    * Restructures player data
    * Creates maps for each position and filters by projected points
    * Creates all possible lineup combinations
    * Filter for salary cap
    * Create lineup details with lineup, salary and total points

  """
  def create_lineups(file, map_position_fun, limit \\ 30_000_000)
  def create_lineups(file, map_position_fun, limit) do
    DailyFantasy.import_players(file)
    |> Enum.map(&Player.create/1)
    |> map_position_fun
    |> DailyFantasy.lineup_combinations_check(limit)
  end

end
