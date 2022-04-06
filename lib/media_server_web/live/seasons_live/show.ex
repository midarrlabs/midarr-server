defmodule MediaServerWeb.SeasonsLive.Show do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  @impl true
  def handle_params(%{"serie" => serie_id, "season" => season_number}, _url, socket) do
    serie = Series.get_serie(serie_id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{serie["title"]}: Season #{season_number}")
      |> assign(:episodes, Episodes.get_all(serie_id, season_number))
    }
  end
end
