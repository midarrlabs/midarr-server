defmodule MediaServerWeb.WatchLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = Movies.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:poster, Movies.get_poster(movie))
      |> assign(:page_title, "#{ movie["title"] }")
      |> assign(:stream_url, "/movies/#{ movie["id"] }/stream")
    }
  end

  @impl true
  def handle_params(%{"episode" => id}, _url, socket) do
    episode = Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:poster, Episodes.get_poster(episode))
      |> assign(:page_title, "#{ episode["series"]["title"] }: #{ episode["title"] }")
      |> assign(:stream_url, "/episodes/#{ episode["id"] }/stream")
    }
  end
end
