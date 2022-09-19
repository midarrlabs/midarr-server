defmodule MediaServerWeb.PlaylistLive.Index do
  use MediaServerWeb, :live_view
  on_mount MediaServerWeb.PlaylistLive.Auth

  alias Phoenix.LiveView.JS
  alias MediaServer.Playlists

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
      socket
      |> assign(:page_title, "Playlists")
      |> assign(:playlist, nil)
    }
  end

  @impl true
  def handle_event("save", %{"playlist" => playlist}, socket) do
    case Playlists.create_playlist(playlist) do
      {:ok, _playlist} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.playlist_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
