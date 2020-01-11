defmodule Tracker.DAL.VisitedLinks do
  @visited_links_db_name "link"
  def save_links(links, time) do
    params = links |> Enum.reduce([], fn link, res -> [time, "#{link}:#{time}" | res] end)
    Redix.command(:redix, ["ZADD", @visited_links_db_name | params])
  end

  def get_links(from, to, is_with_scores \\ false) do
    params = ["ZRANGEBYSCORE", @visited_links_db_name, from, to]
    params = if is_with_scores, do: params ++ ["WITHSCORES"], else: params

    Redix.command(:redix, params)
  end

  def get_original_links(from, to, is_with_scores \\ false) do
    case get_links(from, to, is_with_scores) do
      {:ok, links} -> {:ok, links |> Enum.map(fn l -> l |> String.replace(~r/:\d+$/, "") end)}
      e -> e
    end
  end
end
