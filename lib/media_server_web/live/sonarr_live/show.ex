defmodule MediaServerWeb.SonarrLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Providers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sonarr, Providers.get_sonarr!(id))}
  end

  defp page_title(:show), do: "Show Sonarr"
  defp page_title(:edit), do: "Edit Sonarr"
end
