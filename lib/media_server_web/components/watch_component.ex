defmodule MediaServerWeb.Components.WatchComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Watches

  def handle_event("delete", %{"id" => id}, socket) do
    Watches.delete_movie(Watches.get_movie!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end

  def handle_event("delete_episode", %{"id" => id}, socket) do
    Watches.delete_episode(Watches.get_episode!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end