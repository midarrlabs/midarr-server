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
    library = Media.get_library!(id)
    
    {:noreply,
     socket
     |> assign(:page_title, "#{library.name}")
     |> assign(:library, library |> Repo.preload(:files))
     }
  end

  defp page_title(:edit), do: "Edit Library"
end
