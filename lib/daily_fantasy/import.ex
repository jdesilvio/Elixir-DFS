defmodule DailyFantasy.Import do

  alias DailyFantasy.PlayerRegistry

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

      league_data(:nba)
  """
  def register(:nba) do
    player_data('_data/nba.csv') |>
    Enum.to_list |>
    PlayerRegistry.register
  end
  def register(:nfl) do
    player_data('_data/nfl.csv') |>
    Enum.to_list |>
    PlayerRegistry.register
  end
end
