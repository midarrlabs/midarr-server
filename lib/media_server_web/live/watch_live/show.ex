defmodule MediaServerWeb.WatchLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.WatchStatuses

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = Movies.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{ movie["title"] }")
      |> assign(:id, "#{ movie["id"] }")
      |> assign(:poster, Movies.get_poster(movie))
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

  @impl true
  def handle_event("video_destroyed", %{"user_id" => user_id, "id" => id, "timestamp" => timestamp}, socket) do
    WatchStatuses.update_or_create_movie(id, %{
      movie_id: id,
      timestamp: timestamp,
      user_id: user_id
    })

    {:noreply, socket}
  end
end
