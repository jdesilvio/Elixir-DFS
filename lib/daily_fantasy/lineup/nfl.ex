defmodule NFL do
  @moduledoc """
  Defines an NFL lineup and provided related functions.
  """

  defstruct\
    qb: struct(Player),\
    rb: [struct(Player), struct(Player)],\
    wr: [struct(Player), struct(Player), struct(Player)],\
    te: struct(Player),\
    k: struct(Player),\
    d: struct(Player),\
    total_salary: nil,\
    total_points: nil

end
