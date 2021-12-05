defmodule MediaServerWeb.StreamLive.Show do
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
     |> assign(:file, file)
     |> assign(:page_title, "#{file.title}")
     }
  end
end
