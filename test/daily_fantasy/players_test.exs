Code.require_file("../support/fixture_helpers.ex", __DIR__)

defmodule DailyFantasyTests.PlayersTests do
  use ExUnit.Case

  alias DailyFantasy.Players
  alias DailyFantasy.Players.Player
  alias TestSupport.FixtureHelpers

  @players [%Player{injury_details: "", injury_status: :"",
             name: "Marc Gasol", opponent: :LAL, points: 38.49, position: :C,
             salary: 7100, team: :MEM},
            %Player{injury_details: "", injury_status: :"",
             name: "Al Horford", opponent: :"@PHI", points: 35.37, position: :C,
             salary: 7300, team: :BOS},
            %Player{injury_details: "", injury_status: :"",
             name: "Hassan Whiteside", opponent: :"@POR", points: 43.48,
             position: :C, salary: 8600, team: :MIA},
            %Player{injury_details: "", injury_status: :"",
             name: "Karl-Anthony Towns", opponent: :"@CHA", points: 43.73,
             position: :C, salary: 9400, team: :MIN},
            %Player{injury_details: "", injury_status: :"",
             name: "Rajon Rondo", opponent: :"@DAL", points: 30.27,
             position: :PG, salary: 5900, team: :CHI},
            %Player{injury_details: "", injury_status: :"",
             name: "Goran Dragic", opponent: :"@POR", points: 32.76,
             position: :PG, salary: 7100, team: :MIA}]

  setup_all do
    raw_data = "../fixtures/nba_fixture.csv"
               |> FixtureHelpers.import_fixture

    players = raw_data
              |> Enum.map(&Player.create/1)
              |> Enum.filter(fn(x) -> x.points > 30 end)

    {:ok, players_from_csv: players}
  end

  test "filter players", players do
    filtered_players = players[:players_from_csv]
                       |> Players.filter(40, :C)
                       |> Enum.to_list


    assert filtered_players == [%Player{injury_details: "", injury_status: :"",
                                 name: "Hassan Whiteside", opponent: :"@POR", points: 43.48,
                                 position: :C, salary: 8600, team: :MIA},
                                %Player{injury_details: "", injury_status: :"",
                                 name: "Karl-Anthony Towns", opponent: :"@CHA", points: 43.73,
                                 position: :C, salary: 9400, team: :MIN}]

  end


end
