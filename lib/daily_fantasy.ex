defmodule DailyFantasy do
  use Application
  import Player

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
  def import_players(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

  @doc """
  Filter by projected points.

  Input:
    data - Stream of Players.
    threshold - Players with an expected point total below the threshold
    will be filtered out.

  Output:
    Stream of players whose expected points are greater than or equal to
    the threshold.
  """
  def filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> x.points >= threshold end)
  end

  @doc """
  Filter by postions. Specify the position to be filtered in the "position"
  input.
  """
  def filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x.position == position end)
  end

  @doc """
  Filter by injury.

  Only pass through if there is no injury, probable or questionable
  """
  def filter_by_injury(data) do
    data
    |> Stream.filter(fn(x) -> x.injury_status in [nil, "", "P", "Q"] end)
  end

  @doc """
  Apply player filters.
  """
  def filter_players(data, threshold, position) do
    data
    |> filter_by_points(threshold)
    |> filter_by_injury
    |> filter_by_position(position)
  end

  @doc """
  Construct a map of position maps.

  Filters on a point threshold and maps players to appropriate position.
  Creates combinations for positions requiring multiple players (RB and WR).

  Returns a map for each position.
  """
  def map_positions(data) do
    %{:qb => data |> filter_players(0, "QB") |> Enum.to_list,
      :rb => data |> filter_players(0, "RB") |> Enum.to_list
                  |> Combination.combine(2)
                  |> Enum.map(fn(x) -> %{salary: agg_salary(x, 0), players: x} end),
      :wr => data |> filter_players(0, "WR") |> Enum.to_list
                  |> Combination.combine(3)
                  |> Enum.map(fn(x) -> %{salary: agg_salary(x, 0), players: x} end),
      :te => data |> filter_players(0, "TE") |> Enum.to_list,
      :k  => data |> filter_players(0, "K")  |> Enum.to_list,
      :d  => data |> filter_players(0, "D")  |> Enum.to_list}
  end

  """
  Create lineup combinations by creating every possible combination
  of players.
  """
  def possible_lineups(data) do
    for qb <- data[:qb],
        rb <- data[:rb],
        wr <- data[:wr],
        te <- data[:te],
        k  <- data[:k],
        d  <- data[:d],
        agg_salary([qb, rb, wr, te, k, d], 0) <= 60_000 do
          [qb, rb, wr, te, k, d]
        end
  end

  """
  Aggregate individual salaries form a list of players.
  """
  def agg_salary([h|t], acc) do
    agg_salary(t, h.salary + acc)
  end
  def agg_salary([], acc) do
    acc
  end

  """
  Aggregate individual expected points into expected points for the lineup.
  """
  defp lineup_points([h|t], acc) do
    lineup_points(t, h.points + acc)
  end
  defp lineup_points([], acc) do
    acc
  end

  """
  Flatten nested positions into a lineup.
  """
  def flatten_lineup([h|t], lineup) do
    case Map.get(h, :players) do
      nil ->
        flatten_lineup(t, [h|lineup])
      _ ->
        flatten_lineup(t, [h.players|lineup])
    end
  end
  def flatten_lineup([], lineup) do
    List.flatten(lineup)
  end

  """
  Create a map that has 3 keys:

    * Lineup with all players and details
    * Lineup salary
    * Expected points for lineup

  """
  def create_lineup_details(lineup) do
    flat_lineup = flatten_lineup(lineup, [])

    %{:lineup       => flat_lineup,
      :total_salary => agg_salary(flat_lineup, 0),
      :total_points => lineup_points(flat_lineup, 0)}
  end

  """
  Filter for salary cap. Map to the lineup format.
  """
  def lineup_map(data) do
    data
    |> Enum.map(&create_lineup_details(&1))
  end

  @doc """
  Checks to see if the total number of possible lineups is over a certain threshold.
  """
  def lineup_combinations_check(position_map, limit) do
    if lineup_combinations(position_map) > limit do
      IO.puts Integer.to_string(lineup_combinations(position_map)) <> 
      " is too many lineups!"
    else
      possible_lineups(position_map)
      |> lineup_map
      |> Enum.sort(fn(x, y) -> x[:total_points] > y[:total_points] end)
    end
  end

  @doc """
  Create all possible lineups.

  Executes a series of steps:

    * Imports player data from a file
    * Restructures player data
    * Creates maps for each position and filters by projected points
    * Creates all possible lineup combinations
    * Filter for salary cap ($60,000)
    * Create lineup details with lineup, salary and total points

  """
  def create_lineups(file) do
    import_players(file)
    |> Enum.map(&create_player/1)
    |> map_positions
    |> lineup_combinations_check(30_000_000)
  end

  @doc """
  Print a lineup to the console in a human readable format.
  """
  def print_lineup(lineup) do
    IO.puts "-----------------------------------------------------------------"
    IO.puts "Projected Points: " <> Integer.to_string(round(lineup[:total_points]))
    IO.puts "Total Salary: $" <> Integer.to_string(round(lineup[:total_salary]))
    IO.puts "-----------------------------------------------------------------"
    Enum.map(lineup[:lineup], &print_player/1)
    IO.puts "-----------------------------------------------------------------"
  end

  def print_player(player) do
    IO.puts player.name <> " " <> 
            player.position <> " " <> 
            player.team <> " v. " <> 
            player.opponent <> " | Salary: $" <> 
            Integer.to_string(round(player.salary)) <> " | Points: " <> 
            Integer.to_string(round(player.points))
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
