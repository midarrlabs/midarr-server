defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(:movies, Scrivener.paginate(Movies.get_all(), %{"page" => "3", "page_size" => "10"}))
    }
  end
end
