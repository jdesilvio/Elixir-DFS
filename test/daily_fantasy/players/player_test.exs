Code.require_file("../../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.PlayersTests.PlayerTests do
  use ExUnit.Case

  alias DailyFantasy.Players.Player
  alias TestSupport.FixtureHelpers

  @player %Player{name: "Michael Jordan",
                  team: :CHI,
                  position: :SG,
                  points: 55.9,
                  salary: 8900,
                  opponent: :WORLD,
                  injury_details: "",
                  injury_status: :""}

  setup_all do
    raw_data = "../fixtures/nba_fixture.csv"
               |> FixtureHelpers.import_fixture

    [h|_t] = Enum.take(raw_data, 1)
    player = Player.create(h)

    {:ok, player_from_csv: player}
  end

  test "convert CSV row into a player", player do
    assert player[:player_from_csv] == @player
  end

  test "player.injury_details data type", player do
    injury_details = player[:player_from_csv].injury_details
    assert is_nil(injury_details) or is_binary(injury_details) == true
  end

  test "player.injury_status data type", player do
    injury_status = player[:player_from_csv].injury_status
    assert is_nil(injury_status) or is_atom(injury_status) == true
  end

  test "player.name data type", player do
    assert is_binary(player[:player_from_csv].name) == true
  end

  test "player.opponent data type", player do
    assert is_atom(player[:player_from_csv].opponent)
  end

  test "player.points data type", player do
    points = player[:player_from_csv].points
    assert is_integer(points) or is_float(points) == true
  end

  test "player.position data type", player do
    assert is_atom(player[:player_from_csv].position)
  end

  test "player.salary data type", player do
    assert is_integer(player[:player_from_csv].salary)
  end

  test "player.team data type", player do
    assert is_atom(player[:player_from_csv].team)
  end
end

