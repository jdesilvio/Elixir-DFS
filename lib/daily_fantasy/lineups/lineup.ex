defmodule DailyFantasy.Lineups.Lineup do
  @moduledoc """
  Lineup relates functions.
  """

  alias DailyFantasy.Players.Player

  defstruct lineup: [], total_salary: 0, total_points: 0

  @doc """
  Maps players to a particular position.

  Inputs:
      * players: an Enum of essential player data
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
              |> Enum.map(fn([h|_t]) -> h end)
              |> Enum.map(fn(x) -> elem(x, 1) end)

    total_salary = Enum.reduce(players, 0, fn(x, acc) -> x.salary + acc end)

    IO.puts "-----------------------------------------------------------------"

    IO.puts "Projected Points: " <> (lineup
                                     |> elem(1)
                                     |> (fn(x) -> x / 100 end).()
                                     |> Float.round(1)
                                     |> Float.to_string)

    IO.puts "Total Salary: $" <> (total_salary
                                  |> Integer.to_string)

    IO.puts "-----------------------------------------------------------------"

    Enum.map(players, &Player.print/1)

    IO.puts "-----------------------------------------------------------------"
  end

  @doc """
  Get the total salary of a list of players.

  Inputs:
      * players: an Enum of essential player data

  Returns the total salary of the players.
  """
  def get_salary(players) do
    Enum.reduce(players, 0, fn(x, acc) -> elem(x, 2) + acc end)
  end

end
