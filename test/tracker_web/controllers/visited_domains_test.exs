defmodule TrackerWeb.VisitedDomainsControllerTest do
  use TrackerWeb.ConnCase, async: true

  alias TrackerWeb.Router.Helpers
  alias Tracker.BLL.Utils

  setup do
    {:ok, conn} = Redix.start_link()
    Redix.command!(conn, ["FLUSHALL"])
    Redix.stop(conn)
    :ok
  end

  describe "get" do
    test "with invalid parameter: from not precede to", %{conn: conn} do
      response =
        conn
        |> get(Helpers.visited_domains_path(conn, :index), from: 3, to: 1)
        |> json_response(200)

      assert response == %{"status" => "'from' must precede 'to'"}
    end

    test "with valid parameters", %{conn: conn} do
      conn
      |> post(
        Helpers.visited_links_path(conn, :create),
        links: [
          "https://ya.ru",
          "funbox.ru"
        ]
      )
      |> json_response(200)

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
      |> json_response(200)

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
      |> json_response(200)

      response =
        conn
        |> get(Helpers.visited_domains_path(conn, :index), from: time_from, to: time_to)
        |> json_response(200)

      assert response == %{
               "status" => "ok",
               "links" => ["funbox.ru", "stackoverflow.com", "ya.ru"]
             }

      response =
        conn
        |> get(Helpers.visited_domains_path(conn, :index), from: time_from)
        |> json_response(200)

      assert response == %{
               "status" => "ok",
               "links" => [
                 "funbox.ru",
                 "stackoverflow.com",
                 "ya.ru"
               ]
             }
    end
  end
end
