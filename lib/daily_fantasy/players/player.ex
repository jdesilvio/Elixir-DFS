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
      points: string_to_number(player_data["FPPG"], 2),
      salary: string_to_number(player_data["Salary"]),
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

  defp string_to_number(str, decimals \\ 0)
  defp string_to_number(str, decimals) do
    parsed = _string_to_number(str)

    case is_number(parsed) do
      true  -> integer_or_round(parsed, decimals)
      false -> parsed
    end
  end

  defp _string_to_number(str) do
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

  defp integer_or_round(num, 0), do: round(num)
  defp integer_or_round(num, decimals), do: Float.round(num, decimals)

end
