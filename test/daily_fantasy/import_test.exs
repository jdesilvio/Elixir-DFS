defmodule DailyFantasyTests.ImportTests do
  use ExUnit.Case

  alias DailyFantasy.Import
  alias DailyFantasy.Players.Player

  @player %Player{name: "Michael Jordan",
                  team: :CHI,
                  position: :SG,
                  points: 55.9,
                  salary: 8900,
                  opponent: :WORLD,
                  injury_details: "",
                  injury_status: :""}

  setup_all do
    Import.register(:nba_fixture)
  end

  test "player registry exists" do
    assert :player_registry in :ets.all == true
  end

  test "registry contains players" do
    assert :ets.lookup(:player_registry, 0) == [{0, @player}]
  end

  test "Invalid registry" do
    catch_exit Import.register(:does_not_exist)
  end

end

