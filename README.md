# DailyFantasy

Daily fantasy football lineup optimizer.

### Use in `iEx`:

    data = DailyFantasy.create_lineups("_data/data.csv")

    data |>
    Stream.take(5) |> 
    Enum.map(&DailyFantasy.print_lineup/1)
