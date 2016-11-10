defmodule DailyFantasy do
  use Application
  alias DailyFantasy.Lineups
  alias DailyFantasy.Lineups.Lineup
  alias DailyFantasy.Lineups.Lineup.FanduelNFL

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = []

    opts = [strategy: :one_for_one, name: DailyFantasy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Imports player data from CSV as a Stream.
  """
  def import_player_data(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

end
