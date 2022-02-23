defmodule MediaServerWeb.Components.StatusComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.WatchStatuses

  def handle_event("delete", %{"id" => id}, socket) do
    WatchStatuses.delete_movie(WatchStatuses.get_movie!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end

  def handle_event("delete_episode", %{"id" => id}, socket) do
    WatchStatuses.delete_episode(WatchStatuses.get_episode!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end