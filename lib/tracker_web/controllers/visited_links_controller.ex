defmodule TrackerWeb.VisitedLinksController do
  use TrackerWeb, :controller
  use PhoenixSwagger

  alias TrackerWeb.UtilsController
  alias Tracker.BLL.VisitedLinks

  # coveralls-ignore-start
  def swagger_definitions do
    %{
      LinksRequest:
        swagger_schema do
          title("LinksRequest")
          description("Links on tracked resources")
          property(:links, Schema.array(:string), "Links on tracked resources")

          example(%{
            links: [
              "https://ya.ru",
              "https://ya.ru?q=123",
              "funbox.ru",
              "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
            ]
          })
        end,
      LinksResponse:
        swagger_schema do
          title("LinksResponse")
          description("Links on tracked resources")

          properties do
            links(Schema.array(:string), "Links on tracked resources")
            status(:string, "Response status")
          end

          example(%{
            links: [
              "https://ya.ru",
              "https://ya.ru?q=123",
              "funbox.ru",
              "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
            ],
            status: "ok"
          })
        end,
      OkResponse:
        swagger_schema do
          title("ok response")
          description("Ok status")

          properties do
            status(:string, "Response status")
          end

          example(%{
            status: "ok"
          })
        end
    }
  end

  # coveralls-ignore-stop

  # coveralls-ignore-start
  swagger_path :create do
    summary("Save links")
    description("Save tracked links")
    parameter(:data, :body, Schema.ref(:LinksRequest), "Links")

    response(201, "Links saved", Schema.ref(:OkResponse))
  end

  # coveralls-ignore-stop
  def create(conn, %{"links" => links}) do
    case links |> VisitedLinks.create() do
      {:ok, _} -> conn |> UtilsController.respond_success(201)
      err -> conn |> UtilsController.respond_error(err)
    end
  end

  def create(conn, _) do
    conn |> UtilsController.respond_bad_parameters("links")
  end

  # coveralls-ignore-start
  swagger_path :index do
    summary("Get links")
    description("Get tracked links for a certain period")

    parameter(:from, :query, :number, "Unix start time period",
      required: true,
      example: 1_545_221_231
    )

    parameter(:to, :query, :number, "Unix end time period",
      required: false,
      example: 1_545_217_638
    )

    response(200, "Links for a certain period", Schema.ref(:LinksResponse))
  end

  # coveralls-ignore-stop
  def index(conn, %{"from" => start_time} = params) do
    end_time = Map.get(params, "to")

    case VisitedLinks.index(start_time, end_time) do
      {:ok, links} -> conn |> UtilsController.respond_success(links |> VisitedLinks.to_json())
      err -> conn |> UtilsController.respond_error(err)
    end
  end

  def index(conn, _) do
    conn |> UtilsController.respond_bad_parameters(["from", "to"])
  end
end
