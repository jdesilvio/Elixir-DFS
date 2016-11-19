defmodule DailyFantasy.Lineups.Lineup.FanduelNBA do
  @moduledoc """
  Defines an NBA lineup and provided related functions.
  """

  alias DailyFantasy.Players.Player
  alias DailyFantasy.Players

  defstruct\
    pg: [struct(Player), struct(Player)],\
    sg: [struct(Player), struct(Player)],\
    sf: [struct(Player), struct(Player)],\
    pf: [struct(Player), struct(Player)],\
    c: struct(Player),\
    total_salary: nil,\
    total_points: nil

  @doc """
  Construct a map of position maps.

  Filters on a point threshold and maps players to appropriate position.
  Creates combinations for positions requiring multiple players (RB and WR).

  Returns a map for each position.
  """
  def map_positions(data) do
    %{:pg => data |> Players.filter(0, "PG") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :sg => data |> Players.filter(0, "SG") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :sf => data |> Players.filter(0, "SF") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :pf => data |> Players.filter(0, "PF") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) ->
                    %{salary: Players.agg_salary(x, 0), players: x} end),
      :c  => data |> Players.filter(0, "C")  |> Enum.to_list}
  end
  def map_positions_index do
    essentials = :ets.tab2list(:player_registry)
                 |> Enum.map(&DailyFantasy.Players.Player.essentials/1)

    %{:pg => essentials
           |> Enum.filter(fn x -> elem(x, 1) == :PG end)
           |> Combination.combine(2)
           |> Enum.map(fn(x) ->
             %{salary: Players.agg(x, 0), players: x} end),
      :sg => essentials
           |> Enum.filter(fn x -> elem(x, 1) == :SG end)
           |> Combination.combine(2)
           |> Enum.map(fn(x) ->
             %{salary: Players.agg(x, 0), players: x} end),
      :sf => essentials
           |> Enum.filter(fn x -> elem(x, 1) == :SF end)
           |> Combination.combine(2)
           |> Enum.map(fn(x) ->
             %{salary: Players.agg(x, 0), players: x} end),
      :pf => essentials
           |> Enum.filter(fn x -> elem(x, 1) == :PF end)
           |> Combination.combine(2)
           |> Enum.map(fn(x) ->
             %{salary: Players.agg(x, 0), players: x} end),
      :c  => essentials 
           |> Enum.filter(fn x -> elem(x, 1) == :C end)
           |> Enum.map(fn(x) ->
             %{salary: Players.agg(x, 0), players: x} end)}
  end


  @doc """
  Create lineup combinations by creating every possible combination
  of players.
  """
  def possible_lineups(data) do
    for pg <- data[:pg],
        sg <- data[:sg],
        sf <- data[:sf],
        pf <- data[:pf],
        c  <- data[:c],
        Players.agg_salary([pg, sg, sf, pf, c], 0) <= 60_000 do
          [pg, sg, sf, pf, c]
        end
  end

end
