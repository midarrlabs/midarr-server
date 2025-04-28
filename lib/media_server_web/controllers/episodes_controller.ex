defmodule MediaServerWeb.EpisodesController do
  use MediaServerWeb, :controller

  import Ecto.Query

  def index(conn, params = %{"id" => series_id, "season" => season_id}) do
    {:ok, {episodes, meta}} =
      MediaServer.Episodes
      |> where(series_id: ^series_id)
      |> where(season: ^season_id)
      |> Flop.validate_and_run(params)

    conn
    |> json(%{
      data: episodes,
      meta: %{
        total_pages: meta.total_pages,
        total_count: meta.total_count,
        has_next_page: meta.has_next_page?,
        has_previous_page: meta.has_previous_page?,
        previous_page: meta.previous_page,
        next_page: meta.next_page,
        current_page: meta.current_page
      }
    })
  end

  def show(conn, %{"id" => series_id, "season" => season, "episode" => episode_id}) do
    episode =
      MediaServer.Repo.one(
        from e in MediaServer.Episodes,
          where: e.series_id == ^series_id and e.season == ^season and e.id == ^episode_id
      )

    conn
    |> json(episode)
  end
end
