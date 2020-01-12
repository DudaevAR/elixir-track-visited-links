defmodule Tracker.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    redis_config = Application.get_env(:tracker, Tracker.Redis)

    children = [
      TrackerWeb.Endpoint,
      {Redix,
       host: redis_config[:host],
       port: redis_config[:port],
       password: redis_config[:password],
       database: redis_config[:database],
       name: :redix}
    ]

    opts = [strategy: :one_for_one, name: Tracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
