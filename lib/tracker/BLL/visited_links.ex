defmodule Tracker.BLL.VisitedLinks do
  alias Tracker.BLL.Utils

  def create(links) when is_list(links) do
    if links |> length() == 0 do
      {:err, "The parameter 'links' is empty"}
    else
      time = Utils.get_current_unix_time()
      links |> Tracker.DAL.VisitedLinks.save_links(time)
    end
  end

  def create(_) do
    {:err, "The parameter 'links' must be a list"}
  end

  defp get_links(start_time, end_time) when is_number(start_time) and is_number(end_time),
    do: Tracker.DAL.VisitedLinks.get_original_links(start_time, end_time)

  def index(start_time, end_time) do
    Utils.convert_parameters_and_apply(start_time, end_time, &get_links/2)
  end

  def to_json(links) do
    %{"links" => links}
  end
end
