defmodule MediaServerWeb.HomeLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(page_title: "Home")
    }
  end

  @impl true
  def handle_event("redirect_movies", _params, socket) do
    {:noreply, redirect(socket, to: Routes.movies_index_path(socket, :index))}
  end

  def handle_event("redirect_series", _params, socket) do
    {:noreply, redirect(socket, to: Routes.series_index_path(socket, :index))}
  end

  def handle_event("redirect_continues", _params, socket) do
    {:noreply, redirect(socket, to: Routes.watches_index_path(socket, :index))}
  end
end
