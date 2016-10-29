defmodule QuickSort do
  def qsort(collection, key \\ nil)
  def qsort([], _) do
    []
  end
  def qsort([pivot | rest], key) do
    {left, right} = Enum.partition(rest, fn(x) -> get_value(x, key) < get_value(pivot, key) end)
    qsort(left, key) ++ [pivot] ++ qsort(right, key)
  end

  defp get_value(x, key), do: get_in(x, [Access.key!(key)])
end
