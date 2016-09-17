defmodule DailyFantasy do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(DailyFantasy.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyFantasy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Imports player data from CSV as a Stream.
  """
  defp import_players() do
    File.stream!("_data/data.csv")
    |> CSV.decode(headers: true)
  end

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
  # TODO: should be private, but doctest are discarded for private functions
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

  @doc """
  Filter by projected points. Specify the point threshold as the
  "threshold" input. Anything less than the threshold will be filtered
  out.
  """
  defp filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> number_string_to_float(x["FPPG"]) >= threshold end)
  end

  @doc """
  Filter by postions. Specify the position to be filtered in the "position"
  input.
  """
  defp filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x["Position"] == position end)
  end

  @doc """
  Filters for both a point threshold and a position.
  """
  defp filter_by_points_and_position(data, points, position) do
    data
    |> filter_by_points(points)
    |> filter_by_position(position)
  end

  @doc """
  Construct a map of position maps.

  Starts with an import of the data, then filters on a point threshold
  and a position.

  Returns a map for each position that contains all players for that position
  that passed the points filter.
  """
  def map_positions() do
    data = import_players
    %{:qb => data |> filter_by_points_and_position(20, "QB") |> Enum.to_list,
      :rb => data |> filter_by_points_and_position(15, "RB") |> Enum.to_list,
      :wr => data |> filter_by_points_and_position(15, "WR") |> Enum.to_list,
      :te => data |> filter_by_points_and_position(10, "TE") |> Enum.to_list,
      :k  => data |> filter_by_points_and_position(5, "K") |> Enum.to_list,
      :d  => data |> filter_by_points_and_position(10, "D") |> Enum.to_list}
  end

  @doc """
  Create combinations of players for the same position.

  RB requires combinations of 2.
  WR requires combinations of 3.

  Returns an Enumerable of combinations.
  """
  def position_combos(position_enum, n) do
    position_enum
    |> Combination.combine(n)
  end

  @doc """
  Create a map like map_positions/0, 
  but with the appropriate combinations for RB and WR.
  """
  def map_position_combos() do
    data = map_positions
    %{:qb => data[:qb],
      :rb => data[:rb] |> position_combos(2),
      :wr => data[:wr] |> position_combos(3),
      :te => data[:te],
      :k  => data[:k] ,
      :d  => data[:d]}
  end

  @doc """
  Create lineup combinations by creating every possible combination
  of players.
  """
  def create_lineups() do
    data = map_position_combos
    for qb <- data[:qb],
        rb <- data[:rb],
        wr <- data[:wr],
        te <- data[:te],
        k <- data[:k],
        d <- data[:d] do
          {qb, rb, wr, te, k, d}
        end
  end

  @doc """
  Flatten lineups.
  """
  def flatten_lineups() do
    create_lineups
    |> Enum.map(fn(x) -> Tuple.to_list(x) end)
    |> Enum.map(fn(x) -> List.flatten(x) end)
  end

end
