defmodule MediaServerWeb.MoviesLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"movie" => movie}, _, socket) do
    decoded = MediaServerWeb.Repositories.Movies.get_movie(movie)

    {
      :noreply,
      socket
      |> assign(:page_title, decoded["title"])
      |> assign(:decoded, decoded)
    }
  end

  @impl true
  def handle_event("play", %{"movie" => movie}, socket) do
    {:noreply, push_redirect(socket, to: "/movies/#{ movie }/watch")}
  end
end
