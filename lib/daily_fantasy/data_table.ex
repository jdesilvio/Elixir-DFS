defmodule DailyFantasy.DataTable do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def lookup(key) do
    :ets.lookup(:player_lookup, key)
  end

  def add do
    GenServer.call(__MODULE__, :add)
  end

  # Server callbacks

  def init(:ok) do
    tab = :ets.new(:player_lookup, [:set, :named_table])
    :ets.insert(:player_lookup, {1, "one"})
    {:ok, tab}
  end

  def handle_call(:add, _from, tab) do
    tab = :ets.insert(:player_lookup, {2, "two"})
    {:reply, lookup(2), tab}
  end

end
