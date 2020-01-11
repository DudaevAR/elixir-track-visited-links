defmodule TrackerWeb.VisitedDomainsController do
  use TrackerWeb, :controller

  alias TrackerWeb.UtilsController
  alias Tracker.BLL.VisitedDomains

  def index(conn, %{"from" => from} = params) do
    to = Map.get(params, "to")

    case VisitedDomains.index(from, to) do
      {:ok, links} -> conn |> UtilsController.respond_success(%{"links" => links})
      err -> conn |> UtilsController.respond_error(err)
    end
  end

  def index(conn, _) do
    conn |> UtilsController.respond_bad_parameters(["from", "to"])
  end
end
