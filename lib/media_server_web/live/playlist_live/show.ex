defmodule MediaServerWeb.PlaylistLive.Show do
  use MediaServerWeb, :live_view
  on_mount MediaServerWeb.PlaylistLive.Auth

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply,
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Show Playlist"
  defp page_title(:edit), do: "Edit Playlist"
end
