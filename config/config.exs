# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dsa,
  ecto_repos: [Dsa.Repo]

# Configures the endpoint
config :dsa, DsaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VIuyoCoMNXsIscSo5TTD8OVzW9daxVHKnZ7g2PpvTHLvprLcozy2HPhOBmbhnLkT",
  render_errors: [view: DsaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dsa.PubSub,
  live_view: [signing_salt: "eV1hYRod"]

# Configures Algolia Smart Search
application_id =
  System.get_env("ALGOLIA_APPLICATION_ID_DSA") ||
    raise """
    environment variable ALGOLIA_APPLICATION_ID_DSA is missing.
    """

algolia_admin_api_key =
  System.get_env("ALGOLIA_ADMIN_API_KEY") ||
    raise """
    environment variable ALGOLIA_ADMIN_API_KEY is missing.
    """

config :algolia,
  application_id: application_id,
  api_key: algolia_admin_api_key

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Web Application is in German by Default
config :gettext, default_locale: "de"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
