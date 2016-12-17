defmodule DailyFantasy.Import do
  @moduledoc """
  Provides a mechanism to import player data
  from .csv files to the player registry ETS table.
  """
  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Players.Player

  @doc """
  Imports player data from CSV as a Stream.
  """
  def player_data(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

  @doc """
  Register player data by league.

  Ex:

      DailyFantasy.Import.register(:nba)
      DailyFantasy.Import.register(:nfl)

  """
  def register(league) do
    file = case league do
      :nba -> '_data/nba.csv'
      :nfl -> '_data/nfl.csv'
      _ -> exit "Invalid league"
    end

    player_data(file)
    |> Enum.map(&Player.create/1)
    |> Enum.to_list
    |> PlayerRegistry.register
  end

end
