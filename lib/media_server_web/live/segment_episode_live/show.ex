defmodule MediaServerWeb.SegmentEpisodeLive.Show do
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
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{episode["series"]["title"]}: #{episode["title"]}")
      |> assign(:episode, episode)
      |> assign(:media_stream, Routes.playlist_episode_path(socket, :show, episode["id"], token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", socket.assigns.current_user.id)))
    }
  end
end
