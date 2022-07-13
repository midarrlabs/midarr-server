defmodule MediaServerWeb.SeasonsLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def handle_params(%{"id" => id, "number" => number}, _url, socket) do
    pid = self()

    Task.start(fn ->
      send(pid, {:serie, %{"serie" => Series.get_serie(id), "number" => number}})
    end)

    Task.start(fn ->
      send(pid, {:episodes, Episodes.get_all(id, number)})
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:serie, %{"serie" => serie, "number" => number}}, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "#{serie["title"]}: Season #{number}")
    }
  end

  def handle_info({:episodes, episodes}, socket) do
    {
      :noreply,
      socket
      |> assign(:episodes, episodes)
    }
  end
end
