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
      position: player_data["Position"] |> String.to_atom,
      points: number_string_to_float(player_data["FPPG"]) |> Float.round(2),
      salary: number_string_to_float(player_data["Salary"]) |> round,
      team: player_data["Team"] |> String.to_atom,
      opponent: player_data["Opponent"] |> String.to_atom,
      injury_status: player_data["Injury Indicator"] |> String.to_atom,
      injury_details: player_data["Injury Details"]])
  end

  @doc """
  Print a player to the console in a human readable format.
  """
  def print(player) do
    IO.puts player.name <> " " <>
            (player.position |> Atom.to_string) <> " " <>
            (player.team |> Atom.to_string) <> " v. " <> 
            (player.opponent |> Atom.to_string) <> " | Salary: $" <> 
            (player.salary |> Integer.to_string) <> " | Points: " <> 
            (player.points |> Float.round(1) |> Float.to_string)
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
