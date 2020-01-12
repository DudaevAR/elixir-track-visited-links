defmodule Tracker.BLL.VisitedDomains do
  alias Tracker.BLL.Utils

  defp get_domains_from_links(links) when is_list(links),
    do: Enum.map(links, &get_domains_from_links/1)

  defp get_domains_from_links(link) do
    link_prefix =
      if link |> String.starts_with?(["http://", "https://", "//"]), do: "", else: "http://"

    ((link_prefix <> link) |> URI.parse()).host
  end

  defp get_unique_domains(links) do
    links |> get_domains_from_links() |> MapSet.new() |> MapSet.to_list()
  end

  defp get_domains(start_time, end_time) when is_number(start_time) and is_number(end_time) do
    case Tracker.DAL.VisitedLinks.get_original_links(start_time, end_time) do
      {:ok, links} -> {:ok, links |> get_unique_domains()}
      e -> e
    end
  end

  def index(start_time, end_time) do
    Utils.convert_parameters_and_apply(start_time, end_time, &get_domains/2)
  end

  def to_json(domains) do
    %{"domains" => domains}
  end
end
