defmodule MediaServerWeb.Components.StatusComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.WatchStatuses

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    WatchStatuses.delete_movie(WatchStatuses.get_movie!(id))

    {:noreply, socket}
  end
end