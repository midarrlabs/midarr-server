defmodule MediaServerWeb.WatchLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, MediaServer.Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(%{"movie" => id, "timestamp" => timestamp}, _url, socket) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_id, movie["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_movie_id())
      |> assign(:media_stream, Routes.stream_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()) <> "#t=#{ timestamp }")
      |> assign(:media_subtitle, Routes.subtitle_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_poster, Routes.images_path(socket, :index, movie: movie["id"], type: "background"))
      |> assign(:media_has_subtitle, MediaServer.Subtitles.has_subtitle("#{ MediaServer.MoviesIndex.get_root_path() }/#{ MediaServer.MoviesIndex.get_folder_path(movie) }", MediaServer.MoviesIndex.get_file_path(movie)))
      |> assign(:mime_type, "video/mp4")
    }
  end

  def handle_params(%{"movie" => id}, _url, socket) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_id, movie["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_movie_id())
      |> assign(:media_stream, Routes.stream_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_subtitle, Routes.subtitle_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_poster, Routes.images_path(socket, :index, movie: movie["id"], type: "background"))
      |> assign(:media_has_subtitle, MediaServer.Subtitles.has_subtitle("#{ MediaServer.MoviesIndex.get_root_path() }/#{ MediaServer.MoviesIndex.get_folder_path(movie) }", MediaServer.MoviesIndex.get_file_path(movie)))
      |> assign(:mime_type, "video/mp4")
    }
  end

  def handle_params(%{"episode" => id, "timestamp" => timestamp}, _url, socket) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:media_id, episode["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_episode_id())
      |> assign(:media_stream, Routes.stream_episode_path(socket, :show, episode["id"], token: MediaServer.Token.get_token()) <> "#t=#{ timestamp }")
      |> assign(:media_subtitle, Routes.subtitle_episode_path(socket, :show, episode["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_poster, Routes.images_path(socket, :index, episode: episode["id"], type: "background"))
      |> assign(:media_has_subtitle, MediaServer.Subtitles.has_subtitle("#{ MediaServerWeb.Repositories.Episodes.get_root_path() }/#{ MediaServerWeb.Repositories.Episodes.get_season_path(episode) }/#{ MediaServerWeb.Repositories.Episodes.get_folder_path(episode) }", MediaServerWeb.Repositories.Episodes.get_file_path(episode)))
      |> assign(:mime_type, "video/mp4")
    }
  end

  def handle_params(%{"episode" => id}, _url, socket) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:media_id, episode["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_episode_id())
      |> assign(:media_stream, Routes.stream_episode_path(socket, :show, episode["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_subtitle, Routes.subtitle_episode_path(socket, :show, episode["id"], token: MediaServer.Token.get_token()))
      |> assign(:media_poster, Routes.images_path(socket, :index, episode: episode["id"], type: "background"))
      |> assign(:media_has_subtitle, MediaServer.Subtitles.has_subtitle("#{ MediaServerWeb.Repositories.Episodes.get_root_path() }/#{ MediaServerWeb.Repositories.Episodes.get_season_path(episode) }/#{ MediaServerWeb.Repositories.Episodes.get_folder_path(episode) }", MediaServerWeb.Repositories.Episodes.get_file_path(episode)))
      |> assign(:mime_type, "video/mp4")
    }
  end

  @impl true
  def handle_event(
        "video_destroyed",
        %{
          "current_time" => current_time,
          "duration" => duration
        },
        socket
      ) do
    MediaServer.Continues.update_or_create(%{
      media_id: socket.assigns.media_id,
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id,
      media_type_id: socket.assigns.media_type
    })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    action = MediaServer.Actions.all() |> List.first()

    MediaServer.MediaActions.create(%{
      media_id: socket.assigns.media_id,
      user_id: socket.assigns.current_user.id,
      action_id: action.id,
      media_type_id: socket.assigns.media_type
    })

    {:noreply, socket}
  end
end
