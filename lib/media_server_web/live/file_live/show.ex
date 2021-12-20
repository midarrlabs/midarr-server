defmodule MediaServerWeb.FileLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    file = Media.get_file!(id)

    {:noreply,
     socket
     |> assign(:page_title, "#{file.title} (#{file.year})")
     |> assign(:file, file)
     }
  end

  @impl true
  def handle_event("play", %{"id" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/files/#{id}/watch")}
  end
end
