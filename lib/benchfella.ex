defmodule Bench do
  use Benchfella
  alias DailyFantasy.Lineups.Lineup.FanduelNFL
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Players.Player

  Benchfella.start

  setup_all do
    tab = :ets.new(:player_registry, [:set, :named_table])

    player_data = File.stream!('_data/nba.csv') |> CSV.decode(headers: true)

    player_data
    |> Enum.map(&Player.create/1)
    |> Enum.to_list
    |> Enum.with_index
    |> Enum.map(fn(x) -> {elem(x, 1), elem(x, 0)} end)
    |> Enum.map(fn(x) -> :ets.insert(:player_registry, x) end)
    {:ok, tab}
  end

  bench "Create Lineups From Registry" do
    DailyFantasy.Lineups.create_lineups_index(:FanduelNBA)
  end

  bench "Create Lineups From File" do
   DailyFantasy.Lineups.create_lineups('_data/nba.csv', :FanduelNBA)
  end


end
