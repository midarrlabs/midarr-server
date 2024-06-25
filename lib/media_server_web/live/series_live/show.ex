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
    series = MediaServer.SeriesIndex.all() |> MediaServer.SeriesIndex.find(id)

    query =
      from episode in MediaServer.Episodes,
        where: episode.series_id == ^series["id"]

    episodes = MediaServer.Repo.one(query)

    {
      :noreply,
      socket
      |> assign(:page_title, "#{series["title"]}: Season #{season}")
      |> assign(:series, series)
      |> assign(:season, season)
      |> assign(:episodes, episodes)
    }
  end

  def handle_params(%{"id" => id}, _url, socket) do
    query =
      from episode in MediaServer.Episodes,
        join: series in MediaServer.Series,
        on: episode.series_id == series.id,
        where: series.id == ^id and episode.season == 1,
        preload: [series: series]

    {:ok, {data, _meta}} = Flop.validate_and_run(query, %{order_by: [:number]}, for: MediaServer.Episodes)

    {
      :noreply,
      socket
      |> assign(:page_title, "Series")
      |> assign(:episodes, data)
    }
  end
end
