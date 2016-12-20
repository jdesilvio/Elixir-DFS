defmodule DailyFantasyTests.ImportTests do
  use ExUnit.Case

  alias DailyFantasy.Import
  alias DailyFantasy.Players.Player

  @player %Player{injury_details: "",
                  injury_status: :"",
                  name: "Jahlil Okafor",
                  opponent: :BOS,
                  points: 23.88,
                  position: :C,
                  salary: 4400,
                  team: :PHI}

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

