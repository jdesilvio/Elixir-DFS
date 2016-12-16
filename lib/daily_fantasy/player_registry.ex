defmodule DailyFantasy.PlayerRegistry do
  @moduledoc """
  A GenServer that builds and interacts with a player registry.

  The purpose of this is to import and store player data.
  Most of this data is not needed to build lineups, it is
  only useful when a human wants to view a lineup. This
  provides a way to cache this information and speed up
  the lineup creation/optimization engine.
  """
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

  def handle_cast({:register, player_data}, tab) do
    # Deletes exisiting registry, allowing for re-registering
    :ets.delete_all_objects(:player_registry)

    player_data
    |> Enum.with_index
    |> Enum.map(&tuple_reverse/1)
    |> Enum.map(fn(x) -> :ets.insert(:player_registry, x) end)
    {:noreply, tab}
  end

  # Helpers

  defp tuple_reverse(tuple), do: {elem(tuple, 1), elem(tuple, 0)}

end
