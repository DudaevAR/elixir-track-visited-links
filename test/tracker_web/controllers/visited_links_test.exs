defmodule TrackerWeb.VisitedLinksControllerTest do
  use TrackerWeb.ConnCase
  use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"

  alias TrackerWeb.Router.Helpers
  alias Tracker.BLL.Utils

  setup do
    {:ok, conn} = Redix.start_link()
    Redix.command!(conn, ["FLUSHALL"])
    Redix.stop(conn)
    :ok
  end

  describe "post" do
    test "empty parameter links", %{conn: conn} do
      response =
        conn
        |> post(Helpers.visited_links_path(conn, :create), links: [])
        |> json_response(200)

      assert response == %{"status" => "The parameter 'links' is empty"}
    end

    test "valid parameters", %{conn: conn} do
      response =
        conn
        |> post(
          Helpers.visited_links_path(conn, :create),
          links: [
            "https://ya.ru",
            "https://ya.ru?q=123",
            "funbox.ru",
            "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
          ]
        )
        |> json_response(201)

      assert response == %{"status" => "ok"}
    end

    test "invalid parameters: without links", %{conn: conn} do
      response =
        conn
        |> post(Helpers.visited_links_path(conn, :create))
        |> json_response(200)

      assert response == %{"status" => "Unsupported parameters. Valid parameters: 'links'"}
    end

    test "invalid parameters: links not list", %{conn: conn} do
      response =
        conn
        |> post(Helpers.visited_links_path(conn, :create), links: "https://ya.ru")
        |> json_response(200)

      assert response == %{"status" => "The parameter 'links' must be a list"}
    end
  end

  describe "get" do
    test "without 'from' parameter", %{conn: conn} do
      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index))
        |> json_response(200)

      assert response == %{"status" => "Unsupported parameters. Valid parameters: 'from', 'to'"}
    end

    test "with invalid parameter: from not precede to", %{conn: conn} do
      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index), from: 3, to: 1)
        |> json_response(200)

      assert response == %{"status" => "'from' must precede 'to'"}
    end

    test "with invalid parameter: from not number", %{conn: conn} do
      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index), from: "https://ya.ru")
        |> json_response(200)

      assert response == %{"status" => "The parameters 'from' and 'to' must be numbers"}
    end

    test "with valid parameters", %{conn: conn, swagger_schema: schema} do
      conn
      |> post(
        Helpers.visited_links_path(conn, :create),
        links: [
          "https://ya.ru",
          "funbox.ru"
        ]
      )
      |> validate_resp_schema(schema, "OkResponse")
      |> json_response(201)

      :timer.sleep(1000)
      time_from = Utils.get_current_unix_time()

      conn
      |> post(
        Helpers.visited_links_path(conn, :create),
        links: [
          "https://ya.ru?q=123",
          "funbox.ru",
          "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
        ]
      )
      |> validate_resp_schema(schema, "OkResponse")
      |> json_response(201)

      time_to = Utils.get_current_unix_time()
      :timer.sleep(1000)

      conn
      |> post(
        Helpers.visited_links_path(conn, :create),
        links: [
          "https://ya.ru",
          "funbox.ru"
        ]
      )
      |> validate_resp_schema(schema, "OkResponse")
      |> json_response(201)

      right_response = %{
        "status" => "ok",
        "links" => [
          "funbox.ru",
          "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor",
          "https://ya.ru?q=123"
        ]
      }

      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index), from: time_from, to: time_to)
        |> validate_resp_schema(schema, "LinksResponse")
        |> json_response(200)

      assert response == right_response

      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index),
          from: Integer.to_string(time_from),
          to: Integer.to_string(time_to)
        )
        |> validate_resp_schema(schema, "LinksResponse")
        |> json_response(200)

      assert response == right_response

      right_response = %{
        "status" => "ok",
        "links" => [
          "funbox.ru",
          "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor",
          "https://ya.ru?q=123",
          "funbox.ru",
          "https://ya.ru"
        ]
      }

      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index), from: time_from)
        |> validate_resp_schema(schema, "LinksResponse")
        |> json_response(200)

      assert response == right_response

      response =
        conn
        |> get(Helpers.visited_links_path(conn, :index), from: Integer.to_string(time_from))
        |> validate_resp_schema(schema, "LinksResponse")
        |> json_response(200)

      assert response == right_response
    end
  end
end
