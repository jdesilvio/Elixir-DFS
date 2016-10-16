defmodule DailyFantasy.Lineups.Lineup do
  @moduledoc """
  Lineup relates functions.
  """

  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players
  alias DailyFantasy.Players.Player

  defstruct lineup: [], total_salary: 0, total_points: 0

  @doc """
  Aggregate individual expected points into expected points for the lineup.
  """
  def lineup_points([h|t], acc) do
    lineup_points(t, h.points + acc)
  end
  def lineup_points([], acc) do
    acc
  end

  @doc """
  Create a map that has 3 keys:

    * Lineup with all players and details
    * Lineup salary
    * Expected points for lineup

  """
  def create(lineup) do
    flat_lineup = flatten_lineup(lineup, [])

    %Lineup{:lineup       => flat_lineup,
            :total_salary => Players.agg_salary(flat_lineup, 0),
            :total_points => Lineup.lineup_points(flat_lineup, 0)}
  end

  defp flatten_lineup([h|t], lineup) do
    case Map.get(h, :players) do
      nil ->
        flatten_lineup(t, [h|lineup])
      _ ->
        flatten_lineup(t, [h.players|lineup])
    end
  end
  defp flatten_lineup([], lineup) do
    List.flatten(lineup)
  end

  @doc """
  Print a lineup to the console in a human readable format.
  """
  def print(lineup) do
    IO.puts "-----------------------------------------------------------------"
    IO.puts "Projected Points: " <> Integer.to_string(round(lineup.total_points))
    IO.puts "Total Salary: $" <> Integer.to_string(round(lineup.total_salary))
    IO.puts "-----------------------------------------------------------------"
    Enum.map(Enum.reverse(lineup.lineup), &Player.print/1)
    IO.puts "-----------------------------------------------------------------"
  end

end
