defmodule MediaServerWeb.SeasonsLive.Show do
  use MediaServerWeb, :live_view

  @impl true
  def handle_params(%{"id" => id, "number" => number}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:episodes, MediaServerWeb.Repositories.Episodes.get_all(id, number)})
    end)

    series = MediaServer.SeriesIndex.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{series["title"]}: Season #{number}")
    }
  end

  @impl true
  def handle_info({:episodes, episodes}, socket) do
    {
      :noreply,
      socket
      |> assign(:episodes, episodes)
    }
  end
end
