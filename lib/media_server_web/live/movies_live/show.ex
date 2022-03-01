defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = Movies.get_movie(id)

    {:noreply,
      socket
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
    }
  end
end
