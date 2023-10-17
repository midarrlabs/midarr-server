defmodule MediaServerWeb.Helpers do
  def percentage_complete_from_seconds(current_time, duration) do
    current_time / duration * 100
  end

  def get_pagination_previous_link(page_number) do
    page_number - 1
  end

  def get_pagination_next_link(page_number) do
    page_number + 1
  end

  def reduce_size_for_poster_url(url) do
    String.replace(url, "original", "w342")
  end
end
