use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

config :dsa, :environment, :test

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :dsa, Dsa.Repo,
  username: "postgres",
  password: "postgres",
  database: "dsa_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dsa, DsaWeb.Endpoint,
  http: [port: 4002],
  server: false

config :dsa, Dsa.Mailer,
  adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

config :pbkdf2_elixir, :rounds, 1
