defmodule MediaServerWeb.MoviesLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(page_title: "Movies")
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, :Movies)
    |> assign(:decoded, MediaServerWeb.Repositories.Movies.get_all())
  end
end
