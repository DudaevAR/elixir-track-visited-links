defmodule TrackerWeb.UtilsController do
  use TrackerWeb, :controller

  def respond_success(conn) do
    conn |> json(%{"status" => "ok"})
  end

  def respond_success(conn, fields) do
    conn |> json(Map.merge(%{"status" => "ok"}, fields))
  end

  def respond_error(conn, {:error, %{message: err}}) do
    conn |> respond_error(err)
  end

  def respond_error(conn, {:err, err}) do
    conn |> respond_error(err)
  end

  def respond_error(conn, err) do
    conn |> json(%{"status" => err})
  end

  def respond_bad_parameters(conn, params) do
    params = params |> to_string_
    conn |> respond_error("Unsupported parameters. Valid parameters: #{params}")
  end

  defp to_string_(items) when is_list(items) do
    items
    |> Enum.map(&to_string_/1)
    |> Enum.join(", ")
  end

  defp to_string_(item) when is_binary(item) do
    "'#{item}'"
  end
end
