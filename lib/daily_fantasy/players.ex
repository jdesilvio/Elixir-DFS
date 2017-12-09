defmodule DailyFantasy.Players do
  @moduledoc """
  Functions related to players, i.e. a collection of
  %Player{} structs.
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

  defp filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> x.points >= threshold end)
  end

  defp filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x.position == position end)
  end

  defp filter_by_injury(data) do
    data
    |> Stream.filter(
         fn(x) ->
           x.injury_status in [nil, :"", :P, :Q]
         end
       )
  end

end
