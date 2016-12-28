defmodule DailyFantasy.Import do
  @moduledoc """
  Provides a mechanism to import player data
  from .csv files to the player registry ETS table.
  """
  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Players.Player

  defp player_data(file) do
    file
    |> File.stream!
    |> CSV.decode(headers: true)
  end

  defp file_from_league(league) do
    case league do
      :nba -> '_data/nba.csv'
      :nfl -> '_data/nfl.csv'
      :nba_fixture -> 'test/fixtures/nba_fixture.csv'
      :nfl_fixture -> 'test/fixtures/nfl_fixture.csv'
      _ -> exit "Invalid league"
    end
  end

  @doc """
  Register player data by league.

  Ex:

      DailyFantasy.Import.register(:nba)
      DailyFantasy.Import.register(:nfl)

  """
  def register(league) do
    league
    |> file_from_league
    |> player_data
    |> Enum.map(&Player.create/1)
    |> Enum.to_list
    |> PlayerRegistry.register
  end

end
