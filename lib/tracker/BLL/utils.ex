defmodule Tracker.BLL.Utils do
  def get_current_unix_time() do
    DateTime.utc_now() |> DateTime.to_unix()
  end
end
