defmodule DailyFantasy.Lineups do
  @moduledoc """
  Functions related to lineups, i.e. a collection of %Lineup{} structs.
  """

  alias DailyFantasy.Lineups.Lineup.FanduelNFL
  alias DailyFantasy.Lineups.Lineup.FanduelNBA

  @doc """
  Create all possible lineups.
  """
  def create_lineups(contest, limit \\ 30_000_000)
  def create_lineups(contest, limit) do
    position_map = case contest do
      :FanduelNFL -> FanduelNFL.map_positions
      :FanduelNBA -> FanduelNBA.map_positions
      _ -> exit "Invalid contest"
    end

    total_lineups = lineup_combinations(position_map)

    if total_lineups > limit do
      announce_limit(total_lineups)
    else
      announce_creating(total_lineups)
      _create_lineups(contest, position_map)
      |> lineup_to_indexes_points
      |> Enum.sort(fn(x, y) -> elem(x, 1) > elem(y, 1) end)
    end
  end

  defp announce_limit(total_lineups) do
    IO.puts Integer.to_string(total_lineups) <>
    " is too many lineups!"
  end

  defp announce_creating(total_lineups) do
    IO.puts "Creating " <> 
    Integer.to_string(total_lineups) <>
    " lineups, this could take a while..."
  end

  defp _create_lineups(:FanduelNFL, position_map), do: FanduelNFL.possible_lineups(position_map)
  defp _create_lineups(:FanduelNBA, position_map), do: FanduelNBA.possible_lineups(position_map)

  #  Takes a lineup (an Enum of player essential tuples).
  #
  #  Returns a 2 element tuple:
  #    * Element 1: Enum of player indexes
  #    * Element 2: Total projected points
  defp lineup_to_indexes_points(lineup) do
    Enum.map(lineup,
             fn(x) ->
               Enum.map_reduce(x, 0, fn(x, acc) ->
                 {elem(x, 0), elem(x, 3) + acc}
               end)
             end)
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
