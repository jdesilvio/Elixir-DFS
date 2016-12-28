Code.require_file("../../../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.LineupsTests.LineupTests.FanduelNBATests do
  use ExUnit.Case

  alias DailyFantasy.Import
  alias DailyFantasy.Lineups
  alias DailyFantasy.Lineups.Lineup

  setup_all do
    Import.register(:nba_fixture)
  end

  test "too many combinations to create lineups" do
    assert Lineups.create_lineups(:FanduelNBA, 10) == :ok
  end

  test "create lineups" do
    lineups = Lineups.create_lineups(:FanduelNBA)
    number_of_lineups = Enum.count(lineups)
    [first_lineup|_t] = Enum.take(lineups, 1)

    assert number_of_lineups == 13
    assert first_lineup == {[6, 7, 0, 11, 9, 8, 4, 3, 2], 307.94}
    assert Lineup.print(first_lineup) == :ok
  end

end
