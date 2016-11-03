defmodule Bench do
  use Benchfella
  alias DailyFantasy.Lineups.Lineup.FanduelNFL
  alias DailyFantasy.Lineups.Lineup

  Benchfella.start

  bench "Elixir Standard Library Sort" do
    DailyFantasy.import_players('_data/data.csv')
      |> Enum.map(&DailyFantasy.Players.Player.create/1)
      |> DailyFantasy.Lineups.Lineup.FanduelNFL.map_positions
      |> FanduelNFL.possible_lineups
      |> Enum.map(&Lineup.create/1)
      |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
  end

  bench "Quick Sort" do
    DailyFantasy.import_players('_data/data.csv')
      |> Enum.map(&DailyFantasy.Players.Player.create/1)
      |> DailyFantasy.Lineups.Lineup.FanduelNFL.map_positions
      |> FanduelNFL.possible_lineups
      |> Enum.map(&Lineup.create/1)
      |> DailyFantasy.quicksort
  end

  #  defp gen do
    #  DailyFantasy.import_players('_data/data.csv')
    #  |> Enum.map(&DailyFantasy.Players.Player.create/1)
    #  |> DailyFantasy.Lineups.Lineup.FanduelNFL.map_positions
    #  |> FanduelNFL.possible_lineups
    #  |> Enum.map(&Lineup.create/1)
    #end
end
