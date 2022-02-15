defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"serie" => id}, _, socket) do
    serie = MediaServerWeb.Repositories.Series.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, serie["title"])
      |> assign(:serie, serie)
      |> assign(:episodes, MediaServerWeb.Repositories.Series.get_episodes(id))
    }
  end

  @impl true
  def handle_event("play", %{"episode" => id}, socket) do
    {:noreply, push_redirect(socket, to: "/episodes/#{ id }/watch")}
  end
end
