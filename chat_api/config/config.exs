# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chat_api, ecto_repos: [ChatApi.Repo]

# Configures the endpoint
config :chat_api, ChatApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jKxX/USJWXtTzSiEr15Bw3o3fXGYpsHpM2rUifczzNheCsUhB9/SW3eQ5sxDXzbZ",
  render_errors: [view: ChatApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChatApi.PubSub, adapter: Phoenix.PubSub.PG2]

config :chat_api, ChatApi.Auth.Guardian,
  issuer: "chat_api",
  secret_key: "v0wiiP5C4LmfJnao09kakQ5H/Xtur/+A4mYc4qEDkPWhcsU3HeAV3MQfrGqlVUVs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
