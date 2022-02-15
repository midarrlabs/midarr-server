defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"movie" => id}, _, socket) do
    movie = MediaServerWeb.Repositories.Movies.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, movie["title"])
      |> assign(:movie, movie)
    }
  end

  @impl true
  def handle_event("play", %{"movie" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/movies/#{ id }/watch")}
  end
end
