defmodule DailyFantasy.Lineups do
  @moduledoc """
  Functions related to lineups, i.e. a collection of %Lineup{} structs.
  """

  alias DailyFantasy.Players
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Lineups.Lineup.FanduelNFL
  alias DailyFantasy.Lineups.Lineup.FanduelNBA

  @doc """
  Create all possible lineups.
  """
  def create_lineups(file, contest, limit \\ 30_000_000)
  def create_lineups(file, contest, limit) do
    position_map = case contest do
      :FanduelNFL -> Players.map_players(file) |> FanduelNFL.map_positions
      :FanduelNBA -> Players.map_players(file) |> FanduelNBA.map_positions
    end
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <>
        " is too many lineups!"
      else
        FanduelNFL.possible_lineups(position_map)
        |> Enum.map(&Lineup.create/1)
        |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
     end
  end
  def create_lineups_index(contest, limit \\ 30_000_000)
  def create_lineups_index(contest, limit) do
    position_map = case contest do
      :FanduelNFL -> FanduelNFL.map_positions_index
      :FanduelNBA -> FanduelNBA.map_positions_index
    end
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <>
        " is too many lineups!"
    else
      case contest do
        :FanduelNFL -> FanduelNFL.possible_lineups(position_map)
        |> Enum.map(fn(x) -> %{:total_points => Lineup.lineup_points(x, 0), :players => x} end)
        |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
        :FanduelNBA -> FanduelNBA.possible_lineups(position_map)
        |> Enum.map(fn(x) -> Lineup.flat(x, []) end)
        |> Enum.map(fn(x) -> Enum.map_reduce(x, 0, fn(x, acc) -> {x, elem(x, 3) + acc} end) end)
        |> Enum.map(fn(x) -> %{players: elem(x, 0), total_points: elem(x, 1)} end)
        |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
        |> Enum.map(fn(x) -> {x.total_points, Enum.reduce(x.players, [], fn(x, acc) -> [elem(x, 0)] ++ acc end)} end)
      end
    end
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
