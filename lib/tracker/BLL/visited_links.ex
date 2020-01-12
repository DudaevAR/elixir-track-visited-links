defmodule Tracker.BLL.VisitedLinks do
  alias Tracker.BLL.Utils

  def create(links) when is_list(links) do
    case links |> length() do
      0 ->
        {:err, "The parameter 'links' is empty"}

      _ ->
        time = Utils.get_current_unix_time()
        links |> Tracker.DAL.VisitedLinks.save_links(time)
    end
  end

  def create(_) do
    {:err, "The parameter 'links' must be a list"}
  end

  defp get_links(from, to) when is_number(from) and is_number(to),
    do: Tracker.DAL.VisitedLinks.get_original_links(from, to)

  def index(from, to) do
    Utils.check_parameters(from, to, &get_links/2)
  end
end
