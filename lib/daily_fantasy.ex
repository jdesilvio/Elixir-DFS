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

  """
  Imports player data from CSV as a Stream.
  """
  def import_players(file) do
    File.stream!(file)
    |> CSV.decode(headers: true)
  end

  """
  Restructure the map representation of a player and drop uneccessary data.
  """
  def structure_player(player) do
    %{:player         => player["First Name"] <> " " <> player["Last Name"],
      :position       => player["Position"],
      :points         => number_string_to_float(player["FPPG"]),
      :salary         => number_string_to_float(player["Salary"]),
      :team           => player["Team"],
      :opponent       => player["Opponent"],
      :injury_status  => player["Injury Indicator"],
      :injury_details => player["Injury Details"]}
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

  """
  Filter by projected points. Specify the point threshold as the
  "threshold" input. Anything less than the threshold will be filtered
  out.
  """
  def filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> x[:points] >= threshold end)
  end

  """
  Filter by postions. Specify the position to be filtered in the "position"
  input.
  """
  def filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x[:position] == position end)
  end

  """
  Filter by injury.

  Only pass through if there is no injury, probable or questionable
  """
  def filter_by_injury(data) do
    data
    |> Stream.filter(fn(x) -> x[:injury_status] in [nil, "P", "Q"] == false end)
  end

  """
  Filters for both a point threshold and a position.
  """
  def filter_players(data, points, position) do
    data
    |> filter_by_points(points)
    |> filter_by_injury
    |> filter_by_position(position)
  end

  """
  Construct a map of position maps.

  Filters on a point threshold and maps players to appropriate position.
  Creates combinations for positions requiring multiple players (RB and WR).

  Returns a map for each position.
  """
  def map_positions(data) do
    %{:qb => data |> filter_players(0, "QB") |> Enum.to_list,
      :rb => data |> filter_players(0, "RB") |> Enum.to_list 
                  |> Combination.combine(2),
      :wr => data |> filter_players(0, "WR") |> Enum.to_list 
                  |> Combination.combine(3),
      :te => data |> filter_players(0, "TE") |> Enum.to_list,
      :k  => data |> filter_players(0, "K")   |> Enum.to_list,
      :d  => data |> filter_players(0, "D")   |> Enum.to_list}
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
        k <- data[:k],
        d <- data[:d] do
          List.flatten([qb, rb, wr, te, k, d])
        end
  end

  """
  Aggregate individual salaries into a lineup salary.
  """
  def lineup_salary([h|t], acc) do
    lineup_salary(t, h[:salary] + acc)
  end
  def lineup_salary([], acc) do
    acc
  end

  """
  Filter for salary cap.
  """
  def salary_cap_filter(data) do
    IO.puts "Total lineups: #{Enum.count(data)}"
    data
    |> Stream.filter(fn(x) -> lineup_salary(x, 0) <= 60000 end)
  end

  """
  Aggregate individual expected points into expected points for the lineup.
  """
  defp lineup_points([h|t], acc) do
    lineup_points(t, h[:points] + acc)
  end
  defp lineup_points([], acc) do
    acc
  end

  """
  Create a map that has 3 keys:

    * Lineup with all players and details
    * Lineup salary
    * Expected points for lineup

  """
  def create_lineup_details(lineup) do
    %{:lineup => lineup,
      :total_salary => lineup_salary(lineup, 0),
      :total_points => lineup_points(lineup, 0)}
  end

  """
  Map lineup details.
  """
  def map_lineup_details(data) do
    data
    |> Stream.map(&create_lineup_details/1)
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
    |> Stream.map(&structure_player/1)
    |> map_positions
    |> possible_lineups
    |> salary_cap_filter
    |> map_lineup_details
    |> Enum.sort(fn(x, y) -> x[:total_points] > y[:total_points] end)
  end

  @doc """
  Print a lineup to the console in a human readable format.
  """
  def print_lineup(lineup) do
    IO.puts "---------------------------"
    IO.puts "Projected Points: " <> Integer.to_string(round(lineup[:total_points]))
    IO.puts "Total Salary: $" <> Integer.to_string(round(lineup[:total_salary]))
    IO.puts "---------------------------"
    Enum.map(lineup[:lineup], &print_player/1)
    IO.puts "---------------------------"
  end

  def print_player(player) do
    IO.puts player[:player] <> " " <> 
            player[:position] <> " " <> 
            player[:team] <> " v. " <> 
            player[:opponent] <> " | Salary: $" <> 
            Integer.to_string(round(player[:salary])) <> " | Points: " <> 
            Integer.to_string(round(player[:points]))
  end

end
