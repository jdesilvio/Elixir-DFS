defmodule DailyFantasy.Lineups.Lineup.FanduelNBA do
  @moduledoc """
  Defines an NBA lineup and provided related functions.
  """

  require Logger
  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players.Player

  defstruct\
    pg: [struct(Player), struct(Player)],\
    sg: [struct(Player), struct(Player)],\
    sf: [struct(Player), struct(Player)],\
    pf: [struct(Player), struct(Player)],\
    c: struct(Player),\
    total_salary: nil,\
    total_points: nil

  @doc """
  Construct a map of players for each position.
  """
  def map_positions do
    players = PlayerRegistry.get_essentials

    %{:pg => Lineup.map_position(players, :PG, 2),
      :sg => Lineup.map_position(players, :SG, 2),
      :sf => Lineup.map_position(players, :SF, 2),
      :pf => Lineup.map_position(players, :PF, 2),
      :c  => Lineup.map_position(players, :C, 1)}
  end

  @doc """
  Create lineup combinations by creating every
  possible combination of players.
  """
  #  def possible_lineups(data) do
  #    IO.inspect data
  #    for pg <- data[:pg],
  #        sg <- data[:sg],
  #        sf <- data[:sf],
  #        pf <- data[:pf],
  #        c  <- data[:c],
  #        Enum.reduce(pg ++ sg ++ sf ++ pf ++ c,
  #                    0,
  #                    fn(x, acc) -> elem(x, 2) + acc end) <= 60_000 do
  #          pg ++ sg ++ sf ++ pf ++ c
  #        end
  #  end

  def possible_lineups(data) do
    Logger.info "Starting to create combos"
    combos = for pg <- data[:pg],
        sg <- data[:sg],
        sf <- data[:sf],
        pf <- data[:pf],
        c  <- data[:c],
        do: pg ++ sg ++ sf ++ pf ++ c
    Logger.info "Combos created"
    IO.inspect Enum.take(combos, 1)
    new = combos
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.reduce(fn -> [] end,
                   fn x, acc ->
                     if Lineup.get_salary(x) <= 60_000 do
                       acc ++ [x]
                     else
                       acc
                     end
                   end)
    |> Enum.to_list()
    IO.inspect new
  end




end
