defmodule HomeMiku.MixProject do
  use Mix.Project

  def project do
    [
      app: :home_miku,
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
      mod: {HomeMiku.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:gettext, "~> 0.17"},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:slack, "~> 0.19"}
    ]
  end
end
