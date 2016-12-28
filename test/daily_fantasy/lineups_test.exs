defmodule DailyFantasyTests.LineupsTests do
  use ExUnit.Case

  alias DailyFantasy.Lineups

  @map_for_lineup_combos %{a: [:bob, :joe, :sue],
                           b: [:jack, :jill],
                           c: [:sam, :moe, :bill, :rose]}

  test "lineup combination calculation" do
    assert Lineups.lineup_combinations(@map_for_lineup_combos) == 24
  end

  test "create lineup for invalid contest" do
    catch_exit Lineups.create_lineups(:not_a_contest)
  end

end
