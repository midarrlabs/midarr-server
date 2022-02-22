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
      |> assign(:movie_id, "#{ movie["id"] }")
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
  def handle_event("video_destroyed", %{"movie_id" => movie_id, "current_time" => current_time, "duration" => duration, "user_id" => user_id}, socket) do
    movie = Movies.get_movie(movie_id)

    WatchStatuses.update_or_create_movie(%{
      movie_id: movie_id,
      title: movie["title"],
      image_url: Movies.get_background(movie),
      current_time: current_time,
      duration: duration,
      user_id: user_id
    })

    {:noreply, socket}
  end
end
