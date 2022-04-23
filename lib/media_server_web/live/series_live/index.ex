defmodule MediaServerWeb.SeriesLive.Index do
  use MediaServerWeb, :live_view

  alias MediaServerWeb.Repositories.Series

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Series")
    }
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:series, Series.get_all())
    }
  end
end
