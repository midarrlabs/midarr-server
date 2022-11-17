defmodule MediaServerWeb.SeriesLive.Index do
  use MediaServerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Series")
    }
  end

  @impl true
  def handle_params(%{"page" => page}, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
        :series,
        Scrivener.paginate(MediaServer.SeriesIndex.get_all(), %{
          "page" => page,
          "page_size" => "50"
        })
      )
    }
  end

  def handle_params(_params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(
        :series,
        Scrivener.paginate(MediaServer.SeriesIndex.get_all(), %{
          "page" => "1",
          "page_size" => "50"
        })
      )
    }
  end
end
