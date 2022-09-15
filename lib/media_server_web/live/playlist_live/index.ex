defmodule MediaServerWeb.PlaylistLive.Index do
  use MediaServerWeb, :live_view
  on_mount MediaServerWeb.PlaylistLive.Auth

  alias MediaServer.Playlists
  alias MediaServer.Playlists.Playlist

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Playlist")
    |> assign(:playlist, %Playlist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Playlists")
    |> assign(:playlist, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)
    {:ok, _} = Playlists.delete_playlist(playlist)

    {:noreply, socket |> push_redirect(to: Routes.playlist_index_path(socket, :index))}
  end
end
