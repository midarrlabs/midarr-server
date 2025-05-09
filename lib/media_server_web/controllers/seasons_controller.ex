defmodule MediaServerWeb.SeasonsController do
  use MediaServerWeb, :controller

  import Ecto.Query

  def index(conn, params = %{"id" => series_id}) do
    {:ok, {seasons, meta}} =
      MediaServer.Seasons
      |> where(series_id: ^series_id)
      |> Flop.validate_and_run(params)

    conn
    |> json(%{
      data: seasons,
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

  def show(conn, %{"id" => series_id, "season" => season}) do
    season =
      MediaServer.Repo.one(
        from s in MediaServer.Seasons,
          where: s.series_id == ^series_id and s.number == ^season
      )

    conn
    |> json(season)
  end
end
