defmodule MediaServerWeb.SeasonsLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def handle_params(%{"serie" => id, "season" => number}, _url, socket) do
    serie = Series.get_serie(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{serie["title"]}: Season #{number}")
      |> assign(:episodes, Episodes.get_all(id, number))
    }
  end
end
