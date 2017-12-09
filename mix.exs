defmodule DailyFantasy.Mixfile do
  use Mix.Project

  def project do
    [app: :daily_fantasy,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test,
                         "coveralls.detail": :test,
                         "coveralls.post": :test,
                         "coveralls.html": :test]]
  end

  def application do
    [applications: [:logger],
     mod: {DailyFantasy, []}]
  end

  defp deps do
    [
      {:csv, "~> 1.4.2"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:combination, "~> 0.0.2"},
      {:benchfella, "~> 0.3.0"},
      {:excoveralls, "~> 0.5", only: :test},
      {:flow, "~> 0.11"}
    ]
  end
end
