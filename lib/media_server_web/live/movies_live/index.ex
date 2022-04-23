defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies

  @impl true
  def handle_params(%{"page" => page}, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(
        :movies,
        Scrivener.paginate(Movies.get_all(), %{"page" => page, "page_size" => "50"})
      )
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(
        :movies,
        Scrivener.paginate(Movies.get_all(), %{"page" => "1", "page_size" => "50"})
      )
    }
  end
end
