defmodule MediaServerWeb.SearchLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:movies, MediaServer.MoviesIndex.search(query)})
    end)

    Task.start(fn ->
      send(pid, {:series, MediaServer.SeriesIndex.search(query)})
    end)

    {
      :noreply,
      socket
      |> assign(:page_title, query)
    }
  end

  @impl true
  def handle_info({:movies, movies}, socket) do
    {
      :noreply,
      socket
      |> assign(:movies, movies)
    }
  end

  def handle_info({:series, series}, socket) do
    {
      :noreply,
      socket
      |> assign(:series, series)
    }
  end
end
