defmodule SlackBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :slack_bot,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:gettext] ++ Mix.compilers,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:gettext, :logger],
      mod: {SlackBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.3"},
      {:gettext, "~> 0.17"},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:postgrex, "~> 0.15"},
      {:slack, "~> 0.19"}
    ]
  end
end
