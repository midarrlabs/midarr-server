defmodule MediaServerWeb.WatchLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
      |> assign(:media_timestamp, nil)
    }
  end

  @impl true
  def handle_params(%{"movie" => id, "timestamp" => timestamp}, _url, socket) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_type, "movie")
      |> assign(:media_id, movie["id"])
      |> assign(
        :media_timestamp,
        timestamp
      )
      |> assign(
          :media_playlist,
          ~p"/api/playlist.m3u8?movie=#{movie["id"]}&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?movie=#{movie["id"]}&type=background&token=#{socket.assigns.current_user.api_token.token}"
      )
    }
  end

  def handle_params(%{"movie" => id}, _url, socket) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_type, "movie")
      |> assign(:media_id, movie["id"])
      |> assign(
        :media_playlist,
        ~p"/api/playlist.m3u8?movie=#{movie["id"]}&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?movie=#{movie["id"]}&type=background&token=#{socket.assigns.current_user.api_token.token}"
      )
    }
  end

  def handle_params(%{"episode" => id, "timestamp" => timestamp}, _url, socket) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:media_type, "episode")
      |> assign(:media_id, episode["id"])
      |> assign(
           :media_timestamp,
           timestamp
         )
      |> assign(
           :media_playlist,
           ~p"/api/playlist.m3u8?episode=#{episode["id"]}&token=#{socket.assigns.current_user.api_token.token}"
         )
      |> assign(
        :media_background,
        ~p"/api/images?episode=#{episode["id"]}&type=screenshot&token=#{socket.assigns.current_user.api_token.token}"
      )
    }
  end

  def handle_params(%{"episode" => id}, _url, socket) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:media_type, "episode")
      |> assign(:media_id, episode["id"])
      |> assign(
           :media_playlist,
           ~p"/api/playlist.m3u8?episode=#{episode["id"]}&token=#{socket.assigns.current_user.api_token.token}"
         )
      |> assign(
        :media_background,
        ~p"/api/images?episode=#{episode["id"]}&type=screenshot&token=#{socket.assigns.current_user.api_token.token}"
      )
    }
  end

  @impl true
  def handle_event("video_destroyed", %{"current_time" => current_time, "duration" => duration}, %{assigns: %{media_type: "movie", media_id: movies_id, current_user: %{id: user_id}}} = socket) do

    query =
      from movie in MediaServer.Movies,
        where: movie.radarr_id == ^movies_id

    result = MediaServer.Repo.one(query)

    MediaServer.MovieContinues.insert_or_update(%{
      movies_id: result.id,
      current_time: current_time,
      duration: duration,
      user_id: user_id
      })

    {:noreply, socket}
  end

  def handle_event("video_destroyed", %{"current_time" => current_time, "duration" => duration}, %{assigns: %{media_type: "episode", media_id: episode_id, current_user: %{id: user_id}}} = socket) do

    query =
      from episode in MediaServer.Episodes,
        where: episode.sonarr_id == ^episode_id

    result = MediaServer.Repo.one(query)

    MediaServer.EpisodeContinues.insert_or_update(%{
      episodes_id: result.id,
      current_time: current_time,
      duration: duration,
      user_id: user_id
      })

    {:noreply, socket}
  end
end
