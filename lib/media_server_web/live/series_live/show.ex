defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"serie" => serie}, _, socket) do
    decoded = MediaServerWeb.Repositories.Series.get_serie(serie)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{ decoded["title"] } (#{ decoded["year"] })")
      |> assign(:decoded, decoded)
      |> assign(:episodes, MediaServerWeb.Repositories.Series.get_episodes(serie))
    }
  end

  @impl true
  def handle_event("play", %{"episode" => episode}, socket) do
    {:noreply, push_redirect(socket, to: "/episodes/#{ episode }/watch")}
  end
end
