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
  def handle_event("video_destroyed", %{"current_time" => current_time, "duration" => duration}, %{assigns: %{media_type: "movie", media_id: movie_id, current_user: %{id: user_id}}} = socket) do

    query =
      from m in MediaServer.Movies,
        where: m.external_id == ^movie_id

    result = MediaServer.Repo.one(query)

    MediaServer.MovieContinues.insert_or_update(%{
      movie_id: result.id,
      current_time: current_time,
      duration: duration,
      user_id: user_id
      })

    {:noreply, socket}
  end

  def handle_event("video_destroyed", %{"current_time" => current_time, "duration" => duration}, %{assigns: %{media_id: media_id, current_user: %{id: user_id}}} = socket) do
    MediaServer.MediaContinues.insert_or_update(%{
      media_id: media_id,
      current_time: current_time,
      duration: duration,
      user_id: user_id
      })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    MediaServer.MediaActions.insert_or_update(%{
      media_id: socket.assigns.media_id,
      user_id: socket.assigns.current_user.id,
      action_id: MediaServer.Actions.get_played_id()
      })

    {:noreply, socket}
  end
end
