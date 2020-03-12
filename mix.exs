defmodule Parallel.MixProject do
  use Mix.Project

  def project do
    [
      app: :parallel,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Parallel.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:plug_cowboy, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:myxql, "~> 0.3.3"},
      {:jason, "~> 1.1"}
    ]
  end
end
