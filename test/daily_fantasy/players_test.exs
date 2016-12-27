Code.require_file("../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.PlayersTests do
  use ExUnit.Case

  alias DailyFantasy.Players
  alias DailyFantasy.Players.Player
  alias TestSupport.FixtureHelpers

  @sf_over_30_points [%Player{injury_details: "",
                              injury_status: :"",
                              name: "Larry Bird",
                              opponent: :WORLD,
                              points: 39.89,
                              position: :SF,
                              salary: 7900,
                              team: :BOS},
                      %Player{injury_details: "",
                              injury_status: :"",
                              name: "Scottie Pippen",
                              opponent: :WORLD,
                              points: 32.32,
                              position: :SF,
                              salary: 6400,
                              team: :CHI}]



  setup_all do
    raw_data = "../fixtures/nba_fixture.csv"
               |> FixtureHelpers.import_fixture

    players = raw_data
              |> Enum.map(&Player.create/1)

    {:ok, players_from_csv: players}
  end

  test "filter players", players do
    filtered_players = players[:players_from_csv]
                       |> Players.filter(30, :SF)
                       |> Enum.to_list

    assert filtered_players == @sf_over_30_points
  end


end
