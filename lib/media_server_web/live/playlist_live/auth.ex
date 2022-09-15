defmodule MediaServerWeb.PlaylistLive.Auth do
  import Phoenix.LiveView

  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Playlists

  def on_mount(:default, %{"id" => id}, session, socket) do
    socket = assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(session["user_token"])
      |> Repo.preload(:playlists)
    end)

    playlist = Playlists.get_playlist!(id)

    if playlist.user_id === socket.assigns.current_user.id do
      {:cont,
        socket
        |> assign(:playlist, playlist)}
    else
      {:noreply,
        socket
        |> assign(:playlist, Playlists.get_playlist!(0))}
    end
  end

  def on_mount(:default, _params, session, socket) do
    {:cont,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]) |> Repo.preload(:playlists))
    }
  end
end