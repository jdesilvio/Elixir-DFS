defmodule DailyFantasyTests.LineupsTests.LineupTests do
  use ExUnit.Case

  alias DailyFantasy.Lineups.Lineup

  @player_essential_tuples [{0, :C, 0, 0},
                             {1, :C, 0, 0},
                             {2, :C, 0, 0},
                             {3, :PG, 0, 0},
                             {4, :PG, 0, 0},
                             {5, :PG, 0, 0}]

  test "position mapping - no combinations" do
    position_map =  Lineup.map_position(@player_essential_tuples, :C, 1)
    assert length(position_map) == 3
    assert length(List.flatten(position_map)) == 3

  end

  test "position mapping - with combinations" do
    position_map = Lineup.map_position(@player_essential_tuples, :PG, 2)
    assert length(position_map) == 3
    assert length(List.flatten(position_map)) == 6
  end

end
