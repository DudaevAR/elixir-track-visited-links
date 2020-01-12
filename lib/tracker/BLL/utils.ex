defmodule Tracker.BLL.Utils do
  def get_current_unix_time() do
    DateTime.utc_now() |> DateTime.to_unix()
  end

  def convert_to_integer(v) when is_integer(v), do: {:ok, v}

  def convert_to_integer(v) do
    case Integer.parse(v) do
      :error -> {:err, v}
      {res, _} -> res
    end
  end

  defp convert_parameter_from(v) when is_number(v), do: v
  defp convert_parameter_from(v), do: v |> convert_to_integer()

  defp convert_parameter_to(v) when is_number(v), do: v
  defp convert_parameter_to(v) when is_nil(v), do: get_current_unix_time()
  defp convert_parameter_to(v), do: v |> convert_to_integer()

  defp check_parameters_(from, to, _) when is_number(from) and is_number(to) and from > to,
    do: {:err, "'from' must precede 'to'"}

  defp check_parameters_(from, to, func) when is_number(from) and is_number(to),
    do: func.(from, to)

  defp check_parameters_(_, _, _), do: {:err, "The parameters 'from' and 'to' must be numbers"}

  def check_parameters(from, to, func) do
    from = from |> convert_parameter_from
    to = to |> convert_parameter_to
    check_parameters_(from, to, func)
  end
end
