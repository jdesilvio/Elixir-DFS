defmodule DailyFantasy.Lineups.Lineup do
  @moduledoc """
  Lineup relates functions.
  """

  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players
  alias DailyFantasy.Players.Player

  defstruct lineup: [], total_salary: 0, total_points: 0

  @doc """
  Create a map that has 3 keys:

    * Lineup with all players and details
    * Lineup salary
    * Expected points for lineup

  """
  #  def create(lineup) do
  #    flat_lineup = flatten_lineup(lineup, [])
  #
  #    %Lineup{:lineup       => flat_lineup,
  #            :total_salary => Players.agg_salary(flat_lineup, 0),
  #            :total_points => Lineup.lineup_points(flat_lineup, 0)}
  #  end

  @doc """
  Maps players to a particular position.

  Input:
      * players: an Enum of players mapped to DailyFantasy.Players.Player.essentials/1
      * position: an atom representing the position
      * num_spots: the number of players required at position

  If there are multiple spots needed for a position,
  then combinations of players are created.

  Returns an Enum of players or combinations of players for a position.
  """
  def map_position(players, position, num_spots) do
    players
    |> Enum.filter(fn x -> elem(x, 1) == position end)
    |> Combination.combine(num_spots)
  end

  @doc """
  Print a lineup to the console in a human readable format.
  """
  def print(lineup) do
    players = elem(lineup, 0)
    |> Enum.map(fn(x) -> :ets.lookup(:player_registry, x) end)
    |> Enum.map(fn([h|t]) -> h end)
    |> Enum.map(fn(x) -> elem(x, 1) end)

    total_salary = Enum.reduce(players, 0, fn(x, acc) -> x.salary + acc end)

    IO.puts "-----------------------------------------------------------------"

    IO.puts "Projected Points: " <> Integer.to_string(round(elem(lineup, 1)))
    IO.puts "Total Salary: $" <> Integer.to_string(round(total_salary))

    IO.puts "-----------------------------------------------------------------"

    Enum.map(players, &Player.print/1)

    IO.puts "-----------------------------------------------------------------"
  end

end
