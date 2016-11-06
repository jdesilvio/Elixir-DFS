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

  # TODO: Make this generic and move to Lineups module
  @doc """
  Checks to see if the total number of possible lineups is over a certain threshold.
  """
  def lineup_combinations_check(position_map, limit) do
    if Lineups.lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(Lineups.lineup_combinations(position_map)) <> 
      " is too many lineups!"
    else
      position_map
      |> FanduelNFL.possible_lineups
      |> Enum.map(&Lineup.create/1)
      |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
    end
  end

end
