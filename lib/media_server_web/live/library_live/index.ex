defmodule MediaServerWeb.LibraryLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServer.Libraries
  alias MediaServer.Libraries.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :libraries, list_libraries())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Library")
    |> assign(:library, Libraries.get_library!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Library")
    |> assign(:library, %Library{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Libraries")
    |> assign(:library, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    library = Libraries.get_library!(id)
    {:ok, _} = Libraries.delete_library(library)

    {:noreply, assign(socket, :libraries, list_libraries())}
  end

  defp list_libraries do
    Libraries.list_libraries()
  end
end
