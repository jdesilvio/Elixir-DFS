defmodule DailyFantasy.Players.Player do
  @moduledoc """
  Defines a player and related functions.
  """

  defstruct\
    name: nil,\
    position: nil,\
    salary: nil,\
    points: nil,\
    team: nil,\
    opponent: nil,\
    injury_status: nil,\
    injury_details: nil

  @doc """
  Restructure the map representation of a player and drop uneccessary data.
  """
  def create(player) do
    struct(DailyFantasy.Players.Player,
     [name: player["First Name"] <> " " <> player["Last Name"],
      position: player["Position"],
      points: number_string_to_float(player["FPPG"]),
      salary: number_string_to_float(player["Salary"]),
      team: player["Team"],
      opponent: player["Opponent"],
      injury_status: player["Injury Indicator"],
      injury_details: player["Injury Details"]])
  end

  @doc """
  Print a player to the console in a human readable format.
  """
  def print(player) do
    IO.puts player.name <> " " <> 
            player.position <> " " <> 
            player.team <> " v. " <> 
            player.opponent <> " | Salary: $" <> 
            Integer.to_string(round(player.salary)) <> " | Points: " <> 
            Integer.to_string(round(player.points))
  end

  @doc ~S"""
  If a string contains a valid number and only a valid number,
  then return that number as a float. Otherwise, return the
  original string. If original value is not a string, return nil.

      iex> DailyFantasy.Players.Player.number_string_to_float "13"
      13.0

      iex> DailyFantasy.Players.Player.number_string_to_float "13.99"
      13.99

      iex> DailyFantasy.Players.Player.number_string_to_float "13a"
      "13a"

      iex> DailyFantasy.Players.Player.number_string_to_float "thirteen"
      "thirteen"

      iex> DailyFantasy.Players.Player.number_string_to_float "-13"
      -13.0

      iex> DailyFantasy.Players.Player.number_string_to_float "+13"
      13.0

      iex> DailyFantasy.Players.Player.number_string_to_float nil
      nil

      iex> DailyFantasy.Players.Player.number_string_to_float :an_atom
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

end
