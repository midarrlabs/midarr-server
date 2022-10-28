defmodule MediaServerWeb.PlaylistLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Playlists.Playlist

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    query = from playlist in Playlist, where: playlist.user_id == ^socket.assigns.current_user.id

    playlist = Repo.get!(query, id)

    {:noreply,
     socket
     |> assign(:page_title, playlist.name)
     |> assign(:playlist, playlist |> Repo.preload(playlist_media: [:media]))}
  end
end
