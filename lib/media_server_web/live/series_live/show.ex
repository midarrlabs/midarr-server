defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  alias Phoenix.LiveView.JS

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(
        :current_user,
        MediaServer.Accounts.get_user_by_session_token(session["user_token"])
      )
    }
  end

  @impl true
  def handle_params(%{"id" => id, "season" => season}, _url, socket) do
    series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{series["title"]}: Season #{season}")
      |> assign(:serie, series)
      |> assign(:season, season)
    }
  end

  def handle_params(%{"id" => id}, _url, socket) do
    series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

    season =
      series["seasons"]
      |> Enum.filter(fn x -> x["statistics"]["episodeFileCount"] > 0 end)
      |> List.first()

    {
      :noreply,
      socket
      |> assign(:page_title, "#{series["title"]}: Season #{season["seasonNumber"]}")
      |> assign(:serie, series)
      |> assign(:season, "#{season["seasonNumber"]}")
    }
  end
end
