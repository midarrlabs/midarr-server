defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Movies")
      |> assign(:movies, Movies.get_all())
    }
  end
end
