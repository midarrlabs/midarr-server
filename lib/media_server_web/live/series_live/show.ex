defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series

  @impl true
  def handle_params(%{"serie" => id}, _url, socket) do
    serie = Series.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, serie["title"])
      |> assign(:serie, serie)
    }
  end
end
