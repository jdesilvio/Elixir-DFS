# DailyFantasy

Daily fantasy sports lineup optimizer.

### Use in `iEx`:

    data = DailyFantasy.Lineups.create_lineups('_data/data.csv', &DailyFantasy.Lineups.Lineup.FanduelNFL.map_positions/1)

    data |>
    Enum.take(2) |>
    Enum.map(&DailyFantasy.Lineups.Lineup.print/1)

---

### Release Notes:

#### *Release 0.0.2* aka Barry Sanders:

* Improved speed
* Organized modules

#### *Release 0.0.1* aka Joe Namath:

*Brute force script.* I went at this the same way I'd write a `Python` script or any other "procedural" script in an `Object Oriented` language. The data gets imported and goes through a series of steps until it is transformed into the desired output. There is no utilization of any of the Elixir nicities (maybe `Stream` concurrency) or other advantages of `Funcitonal` programming.

---

####Utilize Processes

I watch a video about creating a neural network in Elixir and a lot of the mistakes I made were made by the presenter and he goes through his thought process and how he made his code more Elixir-like and functional.

https://www.youtube.com/watch?v=YE0h9DURSOo
