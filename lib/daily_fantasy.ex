defmodule DailyFantasy do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(DailyFantasy.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyFantasy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Imports player data from CSV as an Enum.
  """
  def import_as_enum() do
    File.stream!("_data/data.csv")
    |> CSV.decode(headers: true)
    |> Enum.to_list
  end

  @doc """
  Imports player data from CSV as a Stream.
  """
  def import_as_stream() do
    File.stream!("_data/data.csv")
    |> CSV.decode(headers: true)
  end

  @doc"""
  If a string contains a valid number and only a valid number,
  then return that number as a float. Otherwise, return the
  original string.
  """
  def number_string_to_float(str) do
    case Float.parse(str) do
      {num, ""} -> num
      {_num, _r} -> str
      :error    -> str
    end
  end

  @doc """
  Filter into postions.
  """
  def filter_by_position(data) do
    data
    |> Stream.filter(fn(x) -> number_string_to_float(x["FPPG"]) > 5 end)
    |> Enum.to_list
    |> Enum.count
  end

end
