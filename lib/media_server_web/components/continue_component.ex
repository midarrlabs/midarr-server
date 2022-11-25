defmodule MediaServerWeb.Components.ContinueComponent do
  use MediaServerWeb, :live_component

  def handle_event("delete_continue", %{"id" => id}, socket) do
    MediaServer.Continues.delete(id)

    {
      :noreply,
      socket
      |> push_redirect(to: socket.assigns.return_to)
    }
  end
end
