defmodule SynacoreChallenge.Mixfile do
  use Mix.Project

  def project do
    [app: :synacore_challenge,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {SynacoreChallenge.Application, []}]
  end

  defp deps do
    [{:mix_test_watch, "~> 0.3", only: :dev, runtime: false}]
  end
end
