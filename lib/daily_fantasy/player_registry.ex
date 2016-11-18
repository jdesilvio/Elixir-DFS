defmodule DailyFantasy.PlayerRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def lookup(key) do
    :ets.lookup(:player_registry, key)
  end

  def add do
    GenServer.call(__MODULE__, :add)
  end

  def register(player_data) do
    GenServer.cast(__MODULE__, {:register, player_data})
  end

  # Server callbacks

  def init(:ok) do
    tab = :ets.new(:player_registry, [:set, :named_table])
    {:ok, tab}
  end

  def handle_call(:add, _from, tab) do
    tab = :ets.insert(:player_registry, {2, "two"})
    {:reply, lookup(2), tab}
  end

  def handle_cast({:register, player_data}, tab) do
    player_data
    |> Enum.with_index
    |> Enum.map(&tuple_reverse/1)
    |> Enum.map(fn(x) -> :ets.insert(:player_registry, x) end)
    {:noreply, tab}
  end

  # Helpers

  @doc """
  Reverses the order of a 2 element tuple.
  """
  def tuple_reverse(tuple), do: {elem(tuple, 1), elem(tuple, 0)}

end
