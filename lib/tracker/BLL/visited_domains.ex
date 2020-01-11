defmodule Tracker.BLL.VisitedDomains do
  alias Tracker.BLL.Utils

  def get_domain(links) when is_list(links), do: Enum.map(links, &get_domain/1)

  def get_domain(link) do
    link_prefix =
      if link |> String.starts_with?(["http://", "https://", "//"]), do: "", else: "http://"

    ((link_prefix <> link) |> URI.parse()).host
  end

  def get_unique_domains(links) do
    links |> get_domain() |> MapSet.new() |> MapSet.to_list()
  end

  def index(from, to) when is_number(from) and is_number(to) and from > to,
    do: {:err, "'from' must precede 'to'"}

  def index(from, to) when is_number(from) and is_number(to) do
    case Tracker.DAL.VisitedLinks.get_original_links(from, to) do
      {:ok, links} -> {:ok, links |> get_unique_domains()}
      e -> e
    end
  end

  def index(from, nil) when is_number(from) do
    index(from, Utils.get_current_unix_time())
  end

  def index(_, _) do
    {:err, "The parameters 'from' and 'to' must be numbers"}
  end
end
