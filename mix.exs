defmodule SlackBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :slack_bot,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      compilers: [:gettext] ++ Mix.compilers(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
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
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.4"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:exvcr, "~> 0.11", only: :test},
      {:gettext, "~> 0.17"},
      {:ibrowse, "~> 4.4", only: :test},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.2"},
      {:poison, "~> 4.0"},
      {:postgrex, "~> 0.15"},
      {:slack, "~> 0.23"}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
