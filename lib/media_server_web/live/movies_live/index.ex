defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Movies")
    }
  end

  @impl true
  def handle_params(%{"page" => page}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(
        pid,
        {:movies, Scrivener.paginate(Movies.get_all(), %{"page" => page, "page_size" => "50"})}
      )
    end)

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(
        pid,
        {:movies, Scrivener.paginate(Movies.get_all(), %{"page" => "1", "page_size" => "50"})}
      )
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:movies, movies}, socket) do
    {
      :noreply,
      socket
      |> assign(:movies, movies)
    }
  end
end
