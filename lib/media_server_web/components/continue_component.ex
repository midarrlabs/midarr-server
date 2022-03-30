defmodule MediaServerWeb.Components.ContinueComponent do
  use MediaServerWeb, :live_component

  alias MediaServer.Continues

  def handle_event("delete_movie", %{"id" => id}, socket) do
    Continues.delete_movie(Continues.get_movie!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end

  def handle_event("delete_episode", %{"id" => id}, socket) do
    Continues.delete_episode(Continues.get_episode!(id))

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end
