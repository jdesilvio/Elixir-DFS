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
      points: DailyFantasy.number_string_to_float(player["FPPG"]),
      salary: DailyFantasy.number_string_to_float(player["Salary"]),
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

end
