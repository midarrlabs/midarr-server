defmodule MediaServerWeb.SearchLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
      |> assign(page_title: "Search")
    }
  end

  @impl true
  def handle_params(%{"query" => query}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:movies, MediaServer.MoviesIndex.search(MediaServer.MoviesIndex.all(), query)})
    end)

    Task.start(fn ->
      send(pid, {:series, MediaServer.SeriesIndex.search(MediaServer.SeriesIndex.all(), query)})
    end)

    {
      :noreply,
      socket
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {
      :noreply,
      socket
      |> push_redirect(to: Routes.search_index_path(socket, :index, query: query))
    }
  end

  @impl true
  def handle_info({:movies, movies}, socket) do

    ids = Enum.map(movies, fn x -> x["id"] end)

    query = from(item in MediaServer.Movies, where: item.external_id in ^ids)
    results = MediaServer.Repo.all(query)

    {
      :noreply,
      socket
      |> assign(:movies, results)
    }
  end

  def handle_info({:series, series}, socket) do

    ids = Enum.map(series, fn x -> x["id"] end)

    query = from(item in MediaServer.Series, where: item.external_id in ^ids)
    results = MediaServer.Repo.all(query)

    {
      :noreply,
      socket
      |> assign(:series, results)
    }
  end
end
