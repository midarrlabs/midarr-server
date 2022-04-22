defmodule MediaServerWeb.Helpers do
  def minutes_remaining_from_seconds(duration, current_time) do
    ceil((duration - current_time) / 60)
  end

  def percentage_complete_from_seconds(current_time, duration) do
    current_time / duration * 100
  end

  def get_pagination_previous_link(page_number) do
    page_number - 1
  end

  def get_pagination_next_link(page_number, total_pages) do
    page_number + 1
  end
end
