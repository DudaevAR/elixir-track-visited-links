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
      router: TrackerWeb.Router,
      endpoint: TrackerWeb.Endpoint
    ]
  }

import_config "#{Mix.env()}.exs"
