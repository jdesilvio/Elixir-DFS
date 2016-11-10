defmodule DailyFantasy.Players do
  @moduledoc """
  Functions related to players, i.e. a collection os %Player{} structs.
  """

  alias DailyFantasy.Players.Player
  alias DailyFantasy.Import

  @doc """
  Apply player filters.
  """
  def filter(data, threshold, position) do
    data
    |> filter_by_points(threshold)
    |> filter_by_injury
    |> filter_by_position(position)
  end

  """
  Filter by projected points.
  """
  defp filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> x.points >= threshold end)
  end

  """
  Filter by a specified postion.
  """
  defp filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x.position == position end)
  end

  """
  Filter by injury.

  Only pass through if there is no injury, probable or questionable.
  """
  defp filter_by_injury(data) do
    data
    |> Stream.filter(fn(x) -> x.injury_status in [nil, "", "P", "Q"] end)
  end

  @doc """
  Aggregate individual salaries of a list of players.
  """
  def agg_salary([h|t], acc) do
    agg_salary(t, h.salary + acc)
  end
  def agg_salary([], acc) do
    acc
  end

  @doc """
  Imports player data and maps to %Player{} struct.

  Returns an Enum of %Player{} structs.
  """
  def map_players(file) do
    Import.player_data(file)
    |> Enum.map(&Player.create/1)
  end

  @doc """
  Index players.

  Returns a collection of tuples in the form of {%Player{}, index}.
  """
  def index_players(players)
    for x <- Enum.take(players, 5), do: x
  end

  @doc """
  Create a collection if essential player data to minimize the amount of data needed to create lineups.

  Returns a colleciton of tuples in the form of {index, salary, points}.
  """
  def essentials(players_index) do
    for x <- Enum.take(players_index, 5) do
      {elem(x, 1), elem(x, 0).salary, elem(x, 0).points}
    end
  end


end
