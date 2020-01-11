defmodule TrackerWeb.VisitedLinksController do
  use TrackerWeb, :controller

  alias TrackerWeb.UtilsController
  alias Tracker.BLL.VisitedLinks

  def create(conn, %{"links" => links}) do
    case links |> VisitedLinks.create() do
      {:ok, _} -> conn |> UtilsController.respond_success()
      err -> conn |> UtilsController.respond_error(err)
    end
  end

  def create(conn, _) do
    conn |> UtilsController.respond_bad_parameters("links")
  end

  def index(conn, %{"from" => from} = params) do
    to = Map.get(params, "to")

    case VisitedLinks.index(from, to) do
      {:ok, links} -> conn |> UtilsController.respond_success(%{"links" => links})
      err -> conn |> UtilsController.respond_error(err)
    end
  end

  def index(conn, _) do
    conn |> UtilsController.respond_bad_parameters(["from", "to"])
  end
end
