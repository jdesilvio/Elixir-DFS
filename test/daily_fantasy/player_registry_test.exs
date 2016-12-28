defmodule DailyFantasyTests.PlayerRegistryTests do
  use ExUnit.Case

  alias DailyFantasy.PlayerRegistry
  alias DailyFantasy.Import

  setup_all do
    Import.register(:nba_fixture)
    :timer.sleep(1000) # Wait for table to be setup
  end

  test "player registry exists" do
    assert :player_registry in :ets.all == true
  end

  test "player registry is not empty" do
    assert :ets.tab2list(:player_registry) != []
  end

  test "player lookup doesn't return empty" do
    assert PlayerRegistry.lookup(0) != []
  end

end


