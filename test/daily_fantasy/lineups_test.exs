Code.require_file("../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.LineupsTests do
  use ExUnit.Case

  alias DailyFantasy.Import
  alias DailyFantasy.Lineups
  alias DailyFantasy.Lineups.Lineup.FanduelNBA

  @map_for_lineup_combos %{a: [:bob, :joe, :sue],
                           b: [:jack, :jill],
                           c: [:sam, :moe, :bill, :rose]}

  setup_all do
    Import.register(:nba_fixture)
  end

  test "lineup combination calculation" do
    assert Lineups.lineup_combinations(@map_for_lineup_combos) == 24
  end

  test "create lineup for invalid contest" do
    catch_exit Lineups.create_lineups(:not_a_contest)
  end

  test "too many combinations to create lineups" do
    assert Lineups.create_lineups(:FanduelNBA, 1_000_000) == :ok
  end

  test "create lineups" do
    lineups = Lineups.create_lineups(:FanduelNBA)
    number_of_lineups = Enum.count(lineups)
    first_lineup = Enum.take(lineups, 1)

    assert number_of_lineups == 4_917_248
    assert first_lineup == [{[22, 23, 38, 39, 30, 31, 14, 15, 7], 242.23}]
  end


end
