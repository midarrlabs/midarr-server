defmodule MediaServerWeb.PlaylistLive.Index do
  use MediaServerWeb, :live_view

  import Ecto.Query

  alias Phoenix.LiveView.JS
  alias MediaServer.Repo
  alias MediaServer.Accounts
  alias MediaServer.Playlists

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        Accounts.get_user_by_session_token(session["user_token"])
        |> Repo.preload(playlists: from(p in Playlists.Playlist, order_by: [desc: p.id]))
      )
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Playlists")}
  end

  @impl true
  def handle_event("save", %{"playlist" => playlist}, socket) do
    case MediaServer.Playlists.Playlist.create(playlist) do
      {:ok, _playlist} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.playlist_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
