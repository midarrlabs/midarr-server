defmodule MediaServerWeb.LibraryLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServer.Media
  alias MediaServer.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:library, Media.get_library!(id) |> Repo.preload(:files))
     }
  end

  defp page_title(:show), do: "Show Library"
  defp page_title(:edit), do: "Edit Library"
end
