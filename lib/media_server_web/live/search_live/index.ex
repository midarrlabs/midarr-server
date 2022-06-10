defmodule MediaServerWeb.SearchLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, query)
      |> assign(:movies, Movies.search(query))
      |> assign(:series, Series.search(query))
    }
  end
end
