defmodule MediaServerWeb.PlaylistLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Playlists
  alias MediaServer.Accounts

  @impl true
  def mount(_params, session, socket) do
    {:ok,
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(session["user_token"]))
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:playlist, Playlists.get_playlist!(id))}
  end

  defp page_title(:show), do: "Show Playlist"
  defp page_title(:edit), do: "Edit Playlist"
end
