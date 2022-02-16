defmodule MediaServerWeb.SeriesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Series")
      |> assign(:series, Series.get_all())
    }
  end
end
