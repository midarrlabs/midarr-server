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

  def handle_params(%{"movie" => id, "timestamp" => timestamp}, _url, socket) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
      |> assign(:media_stream, Routes.stream_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()) <> "#t=#{ timestamp }")
      |> assign(:mime_type, "video/mp4")
    }
  end

  @impl true
  def handle_params(%{"movie" => id}, _url, socket) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
      |> assign(:media_stream, Routes.stream_movie_path(socket, :show, movie["id"], token: MediaServer.Token.get_token()))
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
      media_id: socket.assigns.movie["id"],
      current_time: current_time,
      duration: duration,
      user_id: socket.assigns.current_user.id,
      media_type_id: MediaServer.MediaTypes.get_movie_id()
    })

    {:noreply, socket}
  end

  def handle_event("video_played", _params, socket) do
    action = MediaServer.Actions.all() |> List.first()

    MediaServer.MediaActions.create(%{
      media_id: socket.assigns.movie["id"],
      user_id: socket.assigns.current_user.id,
      action_id: action.id,
      media_type_id: MediaServer.MediaTypes.get_movie_id()
    })

    {:noreply, socket}
  end
end
