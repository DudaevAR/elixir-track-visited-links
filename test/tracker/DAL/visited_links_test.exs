defmodule Tracker.DAL.VisitedLinksTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, conn} = Redix.start_link()
    Redix.command!(conn, ["FLUSHALL"])
    Redix.stop(conn)
    :ok
  end

  test "save empty list" do
    assert Tracker.DAL.VisitedLinks.save_links([], 0) ==
             {:error, %Redix.Error{message: "ERR wrong number of arguments for 'zadd' command"}}

    assert Tracker.DAL.VisitedLinks.get_original_links(0, 1) == {:ok, []}
  end

  test "save list" do
    links = ["1", "12", "123"]
    assert Tracker.DAL.VisitedLinks.save_links(links, 0) == {:ok, 3}
    assert Tracker.DAL.VisitedLinks.get_original_links(0, 1) == {:ok, ["123", "12", "1"]}
  end

  test "get links with times" do
    links1 = ["12", "1"]
    links2 = ["23", "11", "234"]
    assert Tracker.DAL.VisitedLinks.save_links(links1, 0) == {:ok, 2}
    assert Tracker.DAL.VisitedLinks.save_links(links2, 10) == {:ok, 3}

    assert Tracker.DAL.VisitedLinks.get_original_links(0, 10, true) ==
             {:ok, ["12", "0", "1", "0", "11", "10", "234", "10", "23", "10"]}
  end

  test "get links with filter" do
    links1 = ["1", "2"]
    links2 = ["3", "4"]
    links3 = ["5"]
    links4 = ["6", "7", "3"]

    Tracker.DAL.VisitedLinks.save_links(links1, 0)
    Tracker.DAL.VisitedLinks.save_links(links2, 10)
    Tracker.DAL.VisitedLinks.save_links(links3, 20)
    assert Tracker.DAL.VisitedLinks.save_links(links4, 30) == {:ok, 3}

    assert Tracker.DAL.VisitedLinks.get_original_links(10, 20) == {:ok, links2 ++ links3}
  end
end
