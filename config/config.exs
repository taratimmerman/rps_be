# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rps_api,
  ecto_repos: [RpsApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :rps_api, RpsApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: RpsApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RpsApi.PubSub,
  live_view: [signing_salt: "xPhYuvJg"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :rps_api, RpsApiWeb.Auth.Guardian,
  issuer: "rps_api",
  secret_key: "lsqILSfnc+zLJyP1IcrCP/2vFDcPMM9+b35jFnh/kvJ5nOaruJqfHZq+36LTfnwO"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
  repo: RpsApi.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
