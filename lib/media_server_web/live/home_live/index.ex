defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(page_title: "Home")
    |> assign(:latest_movies, MediaServerWeb.Repositories.Movies.get_latest(6))
    |> assign(:latest_series, MediaServerWeb.Repositories.Series.get_latest(6))
  end
end
