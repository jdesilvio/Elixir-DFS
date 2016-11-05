defmodule DailyFantasy.Lineups do
  @moduledoc """
  Functions related to lineups, i.e. a collection of %Lineup{} structs.
  """

  alias DailyFantasy.Players
  alias DailyFantasy.Players.Player
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Lineups.Lineup.FanduelNFL
  alias DailyFantasy.Lineups.Lineup.FanduelNBA

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
  def create_lineups(file, lineup, limit \\ 30_000_000)
  def create_lineups(file, :FanduelNFL, limit) do
    position_map = Players.map_players(file) |> FanduelNFL.map_positions
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <>
        " is too many lineups!"
      else
        FanduelNFL.possible_lineups(position_map) |> clean
    end
  end
  def create_lineups(file, :FanduelNBA, limit) do
    position_map = Players.map_players(file) |> FanduelNBA.map_positions
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <>
        " is too many lineups!"
      else
        FanduelNBA.possible_lineups(position_map) |> clean
    end
  end


  defp clean(lineups) do
    lineups 
    |> Enum.map(&Lineup.create/1)
    |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
  end

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

end
