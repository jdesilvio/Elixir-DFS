defmodule DailyFantasy do
  use Application
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
  def import_players(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

  # TODO: Make this generic and move to Lineups module
  @doc """
  Checks to see if the total number of possible lineups is over a certain threshold.
  """
  def lineup_combinations_check(position_map, limit) do
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <> 
      " is too many lineups!"
    else
      FanduelNFL.possible_lineups(position_map)
      |> Enum.map(&Lineup.create/1)
      |> Enum.sort(fn(x, y) -> x.total_points > y.total_points end)
    end
  end

  ## Helpers

  @doc ~S"""
  If a string contains a valid number and only a valid number,
  then return that number as a float. Otherwise, return the
  original string. If original value is not a string, return nil.

      iex> DailyFantasy.number_string_to_float "13"
      13.0

      iex> DailyFantasy.number_string_to_float "13.99"
      13.99

      iex> DailyFantasy.number_string_to_float "13a"
      "13a"

      iex> DailyFantasy.number_string_to_float "thirteen"
      "thirteen"

      iex> DailyFantasy.number_string_to_float "-13"
      -13.0

      iex> DailyFantasy.number_string_to_float "+13"
      13.0

      iex> DailyFantasy.number_string_to_float nil
      nil

      iex> DailyFantasy.number_string_to_float :an_atom
      nil

  """
  def number_string_to_float(str) do
    if is_binary(str) do
      case Float.parse(str) do
        {num, ""}  -> num
        {_num, _r} -> str
        :error     -> str
      end
    else
      nil
    end
  end

  # TODO: Make this generic and move to Linups module
  @doc """
  Calculates the total number of possible lineups using the number
  of imported players.

  Returns an integer.
  """
  def lineup_combinations(position_map) do
    Enum.count(position_map.qb) *
    Enum.count(position_map.rb) *
    Enum.count(position_map.wr) *
    Enum.count(position_map.te) *
    Enum.count(position_map.k) *
    Enum.count(position_map.d)
  end

  defp factorial(0), do: 1
  defp factorial(n) when n > 0, do: n * fac(n - 1)

end
