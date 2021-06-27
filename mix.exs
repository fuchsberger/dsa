defmodule Dsa.MixProject do
  use Mix.Project

  def project do
    [
      app: :dsa,
      version: "0.1.17",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      # applications: [],
      mod: {Dsa.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:algolia, "~> 0.8.0"},
      {:bamboo, "~> 2.2.0"},
      {:bcrypt_elixir, "~> 2.3"},
      {:ecto_psql_extras, "~> 0.6.5"},
      {:ecto_sql, "~> 3.6.1"},
      {:enum_type, "~> 1.1.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.18.2"},
      {:jason, "~> 1.0"},
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.3.0"},
      {:phoenix_html, "~> 2.14.3"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_live_reload, "~> 1.3.2", only: :dev},
      {:phoenix_live_view, "~> 0.15.7"},
      {:phx_gen_auth, "~> 0.7.0", only: [:dev], runtime: false},
      {:plug_cowboy, "~> 2.5.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
