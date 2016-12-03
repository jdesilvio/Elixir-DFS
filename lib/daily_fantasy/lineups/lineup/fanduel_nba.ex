defmodule DailyFantasy.Lineups.Lineup.FanduelNBA do
  @moduledoc """
  Defines an NBA lineup and provided related functions.
  """

  alias DailyFantasy.Lineups.Lineup
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
    players = :ets.tab2list(:player_registry)
                 |> Enum.map(&DailyFantasy.Players.Player.essentials/1)

    %{:pg => Lineup.map_position(players, :PG, 2),
      :sg => Lineup.map_position(players, :SG, 2),
      :sf => Lineup.map_position(players, :SF, 2),
      :pf => Lineup.map_position(players, :PF, 2),
      :c  => Lineup.map_position(players, :C, 1)}
  end
  def map_positions_index2 do
    players = :ets.tab2list(:player_registry)
                 |> Enum.map(&DailyFantasy.Players.Player.essentials/1)

    %{:pg => Lineup.map_position2(players, :PG, 2),
      :sg => Lineup.map_position2(players, :SG, 2),
      :sf => Lineup.map_position2(players, :SF, 2),
      :pf => Lineup.map_position2(players, :PF, 2),
      :c  => Lineup.map_position2(players, :C, 1)}
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
  def possible_lineups2(data) do
    for pg <- data[:pg],
        sg <- data[:sg],
        sf <- data[:sf],
        pf <- data[:pf],
        c  <- data[:c],
        Enum.reduce(pg ++ sg ++ sf ++ pf ++ c, 0, fn(x, acc) -> elem(x, 2) + acc end) <= 60_000 do
          pg ++ sg ++ sf ++ pf ++ c
        end
  end


end
