defmodule TestSupport.FixtureHelpers do

  def import_fixture(file) do
    file
    |> Path.expand(__DIR__)
    |> File.stream!
    |> CSV.decode(headers: true)
  end

end
