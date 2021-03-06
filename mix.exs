defmodule Concoction.Mixfile do
  use Mix.Project

  def project do
    [app: :concoction,
     version: "0.1.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:cowboy, :plug],
     mod: {Concoction, []},
     env: [cowboy_port: 8080]]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"}]
  end
end
