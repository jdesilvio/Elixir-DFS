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

  @doc ~S"""
  If a string contains a valid number and only a valid number,
  then return that number as a float. Otherwise, return the
  original string. If original value is not a string, return nil.

      iex> DailyFantasy.number_string_to_float "13"
      13.0

      iex> DailyFantasy.number_string_to_float "13.99"
      13.99

      iex> DailyFantasy.number_string_to_float "13a"
      "13a"

      iex> DailyFantasy.number_string_to_float "thirteen"
      "thirteen"

      iex> DailyFantasy.number_string_to_float "-13"
      -13.0

      iex> DailyFantasy.number_string_to_float "+13"
      13.0

      iex> DailyFantasy.number_string_to_float nil
      nil

      iex> DailyFantasy.number_string_to_float :an_atom
      nil

  """
  def number_string_to_float(str) do
    if is_binary(str) do
      case Float.parse(str) do
        {num, ""}  -> num
        {_num, _r} -> str
        :error     -> str
      end
    else
      nil
    end
  end

  @doc """
  Filter by projected points. Specify the point threshold as the
  "threshold" input. Anything less than the threshold will be filtered
  out.
  """
  def filter_by_points(data, threshold) do
    data
    |> Stream.filter(fn(x) -> number_string_to_float(x["FPPG"]) >= threshold end)
    #|> Enum.to_list
    #|> Enum.count
  end

  @doc """
  Filter by postions. Specify the position to be filtered in the "position"
  input.
  """
  def filter_by_position(data, position) do
    data
    |> Stream.filter(fn(x) -> x["Position"] == position end)
    |> Enum.to_list
    |> Enum.count
  end

end
