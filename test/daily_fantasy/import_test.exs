defmodule DailyFantasyTests.ImportTests do
  use ExUnit.Case

  alias DailyFantasy.Import

  setup_all do
    Import.register(:nba_fixture)
    :timer.sleep(1000) # Wait for table to be setup
  end

  test "registry contains players" do
    [h|_t] = :ets.lookup(:player_registry, 0)

    assert elem(h, 0) == 0
  end

  test "invalid registry" do
    catch_exit Import.register(:does_not_exist)
  end

end

