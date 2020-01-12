defmodule TrackerWeb.Router do
  use TrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TrackerWeb do
    pipe_through :api

    resources "/visited_links", VisitedLinksController, only: [:create, :index]
    resources "/visited_domains", VisitedDomainsController, only: [:index]
  end

  # coveralls-ignore-start
  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :tracker, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "0.1.0",
        title: "Tracker"
      }
    }
  end

  # coveralls-ignore-stop
end
