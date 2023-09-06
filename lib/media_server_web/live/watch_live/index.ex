defmodule MediaServerWeb.WatchLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"movie" => id, "timestamp" => timestamp}, _url, socket) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_id, movie["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_movie_id())
      |> assign(
        :media_stream,
        Routes.stream_path(socket, :index,
          movie: movie["id"],
          token: socket.assigns.current_user.api_token.token
        ) <> "#t=#{timestamp}"
      )
      |> assign(
        :media_subtitle,
        Routes.subtitle_path(socket, :index,
          movie: movie["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_poster,
        ~p"/api/images?movie=#{movie["id"]}&type=poster&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?movie=#{movie["id"]}&type=background&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_has_subtitle,
        MediaServer.Subtitles.has_subtitle(
          movie["folderName"],
          movie["movieFile"]["relativePath"]
        )
      )
      |> assign(:mime_type, "video/mp4")
    }
  end

  def handle_params(%{"movie" => id}, _url, socket) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:media_id, movie["id"])
      |> assign(:media_type, MediaServer.MediaTypes.get_movie_id())
      |> assign(
        :media_stream,
        Routes.stream_path(socket, :index,
          movie: movie["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_subtitle,
        Routes.subtitle_path(socket, :index,
          movie: movie["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_poster,
        ~p"/api/images?movie=#{movie["id"]}&type=poster&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?movie=#{movie["id"]}&type=background&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_has_subtitle,
        MediaServer.Subtitles.has_subtitle(
          movie["folderName"],
          movie["movieFile"]["relativePath"]
        )
      )
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
      |> assign(
        :media_stream,
        Routes.stream_path(socket, :index,
          episode: episode["id"],
          token: socket.assigns.current_user.api_token.token
        ) <> "#t=#{timestamp}"
      )
      |> assign(
        :media_subtitle,
        Routes.subtitle_path(socket, :index,
          episode: episode["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_poster,
        ~p"/api/images?episode=#{episode["id"]}&type=poster&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?episode=#{episode["id"]}&type=screenshot&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_has_subtitle,
        MediaServer.Subtitles.has_subtitle(
          MediaServer.Subtitles.get_parent_path(episode["episodeFile"]["path"]),
          MediaServer.Subtitles.get_file_name(episode["episodeFile"]["relativePath"])
        )
      )
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
      |> assign(
        :media_stream,
        Routes.stream_path(socket, :index,
          episode: episode["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_subtitle,
        Routes.subtitle_path(socket, :index,
          episode: episode["id"],
          token: socket.assigns.current_user.api_token.token
        )
      )
      |> assign(
        :media_poster,
        ~p"/api/images?episode=#{episode["id"]}&type=poster&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_background,
        ~p"/api/images?episode=#{episode["id"]}&type=screenshot&token=#{socket.assigns.current_user.api_token.token}"
      )
      |> assign(
        :media_has_subtitle,
        MediaServer.Subtitles.has_subtitle(
          MediaServer.Subtitles.get_parent_path(episode["episodeFile"]["path"]),
          MediaServer.Subtitles.get_file_name(episode["episodeFile"]["relativePath"])
        )
      )
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
    MediaServer.Continues.insert_or_update(%{
      media_id: socket.assigns.media_id,
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id,
      media_type_id: socket.assigns.media_type
    })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    MediaServer.MediaActions.insert_or_update(%{
      media_id: socket.assigns.media_id,
      user_id: socket.assigns.current_user.id,
      action_id: MediaServer.Actions.get_played_id(),
      media_type_id: socket.assigns.media_type
    })

    {:noreply, socket}
  end
end
