defmodule DailyFantasy.Mixfile do
  use Mix.Project

  def project do
    [app: :daily_fantasy,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {DailyFantasy, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:csv, "~> 1.4.2"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:combination, "~> 0.0.2"},
      {:benchwarmer, "~> 0.0.2"},
      {:benchfella, "~> 0.3.0"}
    ]
  end
end
