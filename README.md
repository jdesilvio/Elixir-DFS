# DailyFantasy

*Daily fantasy sports lineup optimizer.*

### Data

Player data must be in the `_data` directory. File names should be a `CSV`
named after the league that the players are in (i.e. `nba.csv`, `nfl.csv`, etc.)

Mandatory columns are:

* First Name
* Last Name
* Position
* FPPG
* Salary
* Team
* Opponent
* Injury Indicator
* Injury Details

### Use in `iEx`:

    # Register players
    DailyFantasy.Import.register(:nba)

    # Create lineups
    data = DailyFantasy.Lineups.create_lineups(:FanduelNBA)

    # Print lineups
    data |>
    Enum.take(2) |>
    Enum.map(&DailyFantasy.Lineups.Lineup.print/1)

---

### Release Notes:

**Release 0.1.3** aka **_Darrell Green:_**

* ~23% speed improvement by using integers for player point projections instead of floats


**Release 0.1.2** aka **_Grayson "The Professor" Boucher:_**

* 100% test coverage (per coveralls)
* Minor refactoring


**Release 0.1.1** aka **_Tim Duncan:_**

* ~15% speed improvement by optimizing data types for lineup creation
* Invalid input handling


**Release 0.1.0** aka **_William "The Refrigerator" Perry:_**

* A player registry is created as an ETS table upon initialization
* Player data is stored in player registry
* ~10% speed improvement by caching player data and minimizing lineup payload during lineup creation and optimization


**Release 0.0.3** aka **_Lew Alcindor:_**

* Implemeted Fanduel NBA lineup creation
* Implemented a general way to create lineups by specifying the lineup as an `atom`; for example `:FanduelNFL` specifies the structure for Fanduel NFL contests


**Release 0.0.2** aka **_Barry Sanders:_**

* Improved speed
* Organized modules


**Release 0.0.1** aka **_Joe Namath:_**

*Brute force script.* I went at this the same way I'd write a `Python` script or any other "procedural" script in an `Object Oriented` language. The data gets imported and goes through a series of steps until it is transformed into the desired output. There is no utilization of any of the Elixir nicities (maybe `Stream` concurrency) or other advantages of `Functional` programming.
