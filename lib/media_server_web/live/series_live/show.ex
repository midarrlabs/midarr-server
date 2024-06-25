defmodule MediaServerWeb.SeriesLive.Show do
  use MediaServerWeb, :live_view

  import Ecto.Query

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
    query =
      from series in MediaServer.Series,
        where: series.id == ^id,
        join: episode in assoc(series, :episodes),
        where: episode.season == ^season,
        order_by: episode.number,
        preload: [episodes: episode]

    series = MediaServer.Repo.all(query) |> List.first()

    {
      :noreply,
      socket
      |> assign(:page_title, series.title)
      |> assign(:series, series)
      |> assign(:episodes, series.episodes)
      |> assign(:selected_season, season)
    }
  end

  def handle_params(%{"id" => id}, _url, socket) do
    query =
      from series in MediaServer.Series,
        where: series.id == ^id,
        join: episode in assoc(series, :episodes),
        where: episode.season == 1,
        order_by: episode.number,
        preload: [episodes: episode]

    series = MediaServer.Repo.all(query) |> List.first()

    {
      :noreply,
      socket
      |> assign(:page_title, series.title)
      |> assign(:series, series)
      |> assign(:episodes, series.episodes)
      |> assign(:selected_season, "1")
    }
  end

  @impl true
  def handle_event("season", %{"season" => season}, socket) do
    {
      :noreply,
      socket
      |> push_navigate(to: ~p"/series/#{socket.assigns.series.id}?season=#{season}")
    }
  end
end
