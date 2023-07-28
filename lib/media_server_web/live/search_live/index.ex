defmodule MediaServerWeb.SearchLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
      |> assign(page_title: "Search")
    }
  end

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:movies, MediaServer.MoviesIndex.search(query)})
    end)

    Task.start(fn ->
      send(pid, {:series, MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.search(query)})
    end)

    {
      :noreply,
      socket
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
