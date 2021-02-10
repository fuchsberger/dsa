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

# Configures sending emails
config :dsa, Dsa.Mailer,
  adapter: Bamboo.SendinBlueAdapter,
  api_key: System.get_env("SENDINBLUE_APIKEY")


config :dsa, Dsa.Mailer,
  adapter: Bamboo.MailjetAdapter,
  api_key: System.get_env("MAILJET_PUBLIC_KEY"),
  api_private_key: System.get_env("MAILJET_PRIVATE_KEY")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
