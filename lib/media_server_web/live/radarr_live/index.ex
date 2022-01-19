defmodule MediaServerWeb.RadarrLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Integrations
  alias MediaServer.Integrations.Radarr

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :radarrs, list_radarrs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Radarr")
    |> assign(:radarr, Integrations.get_radarr!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Radarr")
    |> assign(:radarr, %Radarr{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Radarrs")
    |> assign(:radarr, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    radarr = Integrations.get_radarr!(id)
    {:ok, _} = Integrations.delete_radarr(radarr)

    {:noreply, assign(socket, :radarrs, list_radarrs())}
  end

  defp list_radarrs do
    Integrations.list_radarrs()
  end
end
