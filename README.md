# DailyFantasy

Daily fantasy football lineup optimizer.

### Use in `iEx`:

    data = DailyFantasy.create_lineups("_data/data.csv")

    data |>
    Stream.take(5) |> 
    Enum.map(&DailyFantasy.print_lineup/1)

---

### Notes:

####Initial Attempt (Release 0.0.1):

*Brute force script.* I went at this the same way I'd write a `Python` script or any other "procedural" script in an `Object Oriented` language. The data gets imported and goes through a series of steps until it is transformed into the desired output. There is no utilization of any of the Elixir nicities (maybe `Stream` concurrency) or other advantages of `Funcitonal` programming.
