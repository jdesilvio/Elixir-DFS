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
  def create_player(player) do
    struct(Player, [name: player["First Name"] <> " " <> player["Last Name"],
                    position: player["Position"],
                    points: DailyFantasy.number_string_to_float(player["FPPG"]),
                    salary: DailyFantasy.number_string_to_float(player["Salary"]),
                    team: player["Team"],
                    opponent: player["Opponent"],
                    injury_status: player["Injury Indicator"],
                    injury_details: player["Injury Details"]])
  end

end
