defmodule Bench do
  use Benchfella


  alias DailyFantasy.Players.Player
  alias DailyFantasy.Lineups
  alias DailyFantasy.Lineups.Lineup.FanduelNBA

  Benchfella.start

  setup_all do
    tab = :ets.new(:player_registry, [:set, :named_table])

    File.stream!('_data/nba_fixture.csv')
    |> CSV.decode(headers: true)
    |> Enum.map(&Player.create/1)
    |> Enum.to_list
    |> Enum.with_index
    |> Enum.map(fn(x) -> {elem(x, 1), elem(x, 0)} end)
    |> Enum.map(fn(x) -> :ets.insert(:player_registry, x) end)
    {:ok, tab}
  end

  bench "Create Lineups From Registry" do
    Lineups.create_lineups(:FanduelNBA)
  end

  bench "Map Positions" do
    FanduelNBA.map_positions
  end

  bench "Create Possible Lineups" do
    FanduelNBA.map_positions
    |> FanduelNBA.possible_lineups
  end

end
