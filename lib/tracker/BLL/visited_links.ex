defmodule Tracker.BLL.VisitedLinks do
  alias Tracker.BLL.Utils

  def create(links) when is_list(links) do
    time = Utils.get_current_unix_time()

    case links |> length() do
      0 -> {:err, "The parameter 'links' is empty"}
      _ -> links |> Tracker.DAL.VisitedLinks.save_links(time)
    end
  end

  def create(_) do
    {:err, "The parameter 'links' must be a list"}
  end

  def index(from, to) when is_number(from) and is_number(to) do
    case from > to do
      true -> {:err, "'from' must precede 'to'"}
      false -> Tracker.DAL.VisitedLinks.get_original_links(from, to)
    end
  end

  def index(from, nil) when is_number(from) do
    to = Utils.get_current_unix_time()
    index(from, to)
  end

  def index(_, _) do
    {:err, "The parameters 'from' and 'to' must be numbers"}
  end
end
