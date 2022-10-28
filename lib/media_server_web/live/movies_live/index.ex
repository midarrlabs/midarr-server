defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

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
    {
      :noreply,
      socket
      |> assign(
        :movies,
        Scrivener.paginate(MediaServer.MovieIndexer.get_all(), %{"page" => page, "page_size" => "50"})
      )
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
        :movies,
        Scrivener.paginate(MediaServer.MovieIndexer.get_all(), %{"page" => "1", "page_size" => "50"})
      )
    }
  end
end
