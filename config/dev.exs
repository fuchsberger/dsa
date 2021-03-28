use Mix.Config

config :dsa, :environment, :dev

# Configure your database
config :dsa, Dsa.Repo,
  username: "postgres",
  password: "postgres",
  database: "dsa_dev",
  hostname: "localhost",
  # log: false,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :dsa, Dsa.Mailer,
  adapter: Bamboo.LocalAdapter

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :dsa, DsaWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true, # switch to true to test error pages
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--color",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :dsa, DsaWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/dsa_web/(live|views)/.*(ex)$",
      ~r"lib/dsa_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
