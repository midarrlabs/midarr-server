defmodule MediaServerWeb.PlaylistLive.Show do
  use MediaServerWeb, :live_view
  on_mount MediaServerWeb.PlaylistLive.Auth

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    {:noreply,
      socket
      |> assign(:page_title, socket.assigns.playlist.name)}
  end
end
