defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def handle_params(%{"serie" => id}, _url, socket) do
    serie = Series.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, serie["title"])
      |> assign(:serie, serie)
      |> assign(:episodes, Episodes.get_all(id))
    }
  end

  @impl true
  def handle_event("play", %{"episode" => id}, socket) do
    {:noreply, push_redirect(socket, to: Routes.watch_episode_show_path(socket, :show, id))}
  end
end
