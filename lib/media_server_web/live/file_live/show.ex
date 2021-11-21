defmodule MediaServerWeb.FileLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:file, Media.get_file!(id))
     }
  end

  @impl true
  def handle_event("play", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/files/#{id}/stream")}
  end
end
