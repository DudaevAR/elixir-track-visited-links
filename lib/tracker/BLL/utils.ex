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

  defp convert_start_time_to_number(v) when is_number(v), do: v
  defp convert_start_time_to_number(v), do: v |> convert_to_integer()

  defp convert_end_time_to_number(v) when is_number(v), do: v
  defp convert_end_time_to_number(v) when is_nil(v), do: get_current_unix_time()
  defp convert_end_time_to_number(v), do: v |> convert_to_integer()

  defp apply_with_validate(start_time, end_time, _)
       when is_number(start_time) and is_number(end_time) and start_time > end_time,
       do: {:err, "'from' must precede 'to'"}

  defp apply_with_validate(start_time, end_time, func)
       when is_number(start_time) and is_number(end_time),
       do: func.(start_time, end_time)

  defp apply_with_validate(_, _, _),
    do: {:err, "The parameters 'from' and 'to' must be numbers"}

  def convert_parameters_and_apply(start_time, end_time, func) do
    start_time = start_time |> convert_start_time_to_number
    end_time = end_time |> convert_end_time_to_number
    apply_with_validate(start_time, end_time, func)
  end
end
