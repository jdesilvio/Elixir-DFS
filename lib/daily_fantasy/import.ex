defmodule DailyFantasy.Import do

  @doc """
  Imports player data from CSV as a Stream.
  """
  def player_data(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

end
