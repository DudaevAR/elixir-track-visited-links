defmodule TrackerWeb.VisitedDomainsController do
  use TrackerWeb, :controller
  use PhoenixSwagger

  alias TrackerWeb.UtilsController
  alias Tracker.BLL.VisitedDomains
  # coveralls-ignore-start
  def swagger_definitions do
    %{
      DomainsResponse:
        swagger_schema do
          title("DomainsResponse")
          description("Response schema for single tag")

          properties do
            domains(Schema.array(:string), "Tracked resources's domains")
            status(:string, "Response status")
          end

          example(%{
            domains: [
              "ya.ru",
              "funbox.ru",
              "stackoverflow.com"
            ],
            status: "ok"
          })
        end
    }
  end

  # coveralls-ignore-stop
  # coveralls-ignore-start
  swagger_path :index do
    summary("Get unique domains")
    description("Get tracked unique domains for a certain period")

    parameter(:from, :query, :number, "Unix start time period",
      required: true,
      example: 1_545_221_231
    )

    parameter(:to, :query, :number, "Unix end time period",
      required: false,
      example: 1_545_217_638
    )

    response(200, "Domains for a certain period", Schema.ref(:DomainsResponse))
  end

  # coveralls-ignore-stop
  def index(conn, %{"from" => start_time} = params) do
    end_time = Map.get(params, "to")

    case VisitedDomains.index(start_time, end_time) do
      {:ok, domains} ->
        conn |> UtilsController.respond_success(domains |> VisitedDomains.to_json())

      err ->
        conn |> UtilsController.respond_error(err)
    end
  end

  def index(conn, _) do
    conn |> UtilsController.respond_bad_parameters(["from", "to"])
  end
end
