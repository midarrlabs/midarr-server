defmodule MediaServerWeb.WatchMovieLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Watches

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = Movies.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{ movie["title"] }")
      |> assign(:movie_id, "#{ movie["id"] }")
      |> assign(:background, Movies.get_background(movie))
      |> assign(:stream_url, "/movies/#{ movie["id"] }/stream")
    }
  end

  @impl true
  def handle_event("movie_destroyed", %{"movie_id" => movie_id, "current_time" => current_time, "duration" => duration, "user_id" => user_id}, socket) do
    movie = Movies.get_movie(movie_id)

    Watches.update_or_create_movie(%{
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
