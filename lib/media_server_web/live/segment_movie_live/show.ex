defmodule MediaServerWeb.SegmentMovieLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
           :current_user,
           Accounts.get_user_by_session_token(session["user_token"])
           |> Repo.preload(:continues)
         )
      |> assign(:mime_type, "application/x-mpegURL")
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{movie["title"]}")
      |> assign(:movie, movie)
      |> assign(:media_stream, Routes.playlist_movie_path(socket, :show, movie["id"], token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", socket.assigns.current_user.id)))
    }
  end
end
