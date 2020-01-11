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
end
