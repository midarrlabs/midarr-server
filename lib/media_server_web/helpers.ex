defmodule MediaServerWeb.Helpers do

  def minutes_remaining_from_seconds(duration, current_time) do
    ceil((duration - current_time) / 60)
  end

  def percentage_complete_from_seconds(current_time, duration) do
    (current_time / duration) * 100
  end
end
