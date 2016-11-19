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
  Restructure raw player data into a %Player{} struct.
  """
  def create(player_data) do
    struct(DailyFantasy.Players.Player,
     [name: player_data["First Name"] <> " " <> player_data["Last Name"],
      position: player_data["Position"],
      points: number_string_to_float(player_data["FPPG"]),
      salary: number_string_to_float(player_data["Salary"]),
      team: player_data["Team"],
      opponent: player_data["Opponent"],
      injury_status: player_data["Injury Indicator"],
      injury_details: player_data["Injury Details"]])
  end

  @doc """
  Create a tuple of essential player data to minimize
  the amount of data needed to create lineups.

  Input: An indexed player from the registry in the form of {index, %Player{}}.
  Return: A tuple in the form of {index, position, salary, points}.
  """
  def essentials(indexed_player) do
    {elem(indexed_player, 0),
     elem(indexed_player, 1).position |> String.to_atom,
     elem(indexed_player, 1).salary,
     elem(indexed_player, 1).points}
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
