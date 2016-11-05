defmodule DailyFantasy.Players do
  @moduledoc """
  Functions related to players, i.e. a collection os %Player{} structs.
  """

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

end