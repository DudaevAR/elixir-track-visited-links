# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :tracker, TrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ySI3NSoXTyaBatKhmIwRgoZ8Q9f6eT/eN4RqwfVwlcr+4K2xzf82Pc2F6Jh5nm1D",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Tracker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Redis
config :tracker, Tracker.Redis,
  host: System.get_env("REDIS_HOST") || "0.0.0.0",
  port: System.get_env("REDIS_PORT") || 6379,
  password: System.get_env("REDIS_PASSWORD") || nil,
  database: System.get_env("REDIS_DATABASE") || nil

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Swagger
config :tracker, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: TrackerWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: TrackerWeb.Endpoint
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
