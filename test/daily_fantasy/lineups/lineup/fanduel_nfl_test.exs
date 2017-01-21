Code.require_file("../../../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.LineupsTests.LineupTests.FanduelNFLTests do
  use ExUnit.Case

  alias DailyFantasy.Import
  alias DailyFantasy.Lineups
  alias DailyFantasy.Lineups.Lineup

  setup_all do
    Import.register(:nfl_fixture)
    :timer.sleep(1000) # Wait for table to be setup
  end

  test "too many combinations to create lineups" do
    assert Lineups.create_lineups(:FanduelNFL, 10) == :ok
  end

  test "create lineups" do
    lineups = Lineups.create_lineups(:FanduelNFL)
    number_of_lineups = Enum.count(lineups)
    [first_lineup|_t] = Enum.take(lineups, 1)

    assert number_of_lineups == 156
    assert first_lineup == {[2, 5, 6, 9, 10, 11, 8, 13, 0], 16647}
    assert Lineup.print(first_lineup) == :ok
  end

end
