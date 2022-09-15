defmodule MediaServerWeb.PlaylistLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Repo
  alias MediaServer.Playlists
  alias MediaServer.Playlists.Playlist
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     socket
     |> assign(
       :current_user,
       Accounts.get_user_by_session_token(session["user_token"]) |> Repo.preload(:playlists)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do

    playlist = Playlists.get_playlist!(id)

    if playlist.user_id != socket.assigns.current_user.id do
      socket
      |> push_redirect(to: Routes.playlist_index_path(socket, :index))
    else
      socket
      |> assign(:page_title, "Edit Playlist")
      |> assign(:playlist, Playlists.get_playlist!(id))
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Playlist")
    |> assign(:playlist, %Playlist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Playlists")
    |> assign(:playlist, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)
    {:ok, _} = Playlists.delete_playlist(playlist)

    {:noreply, socket |> push_redirect(to: Routes.playlist_index_path(socket, :index))}
  end
end
