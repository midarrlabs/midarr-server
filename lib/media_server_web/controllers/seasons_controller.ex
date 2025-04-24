defmodule MediaServerWeb.SeasonsController do
  use MediaServerWeb, :controller

  import Ecto.Query

  def index(conn, params = %{"id" => id}) do
    {:ok, {seasons, meta}} =
      MediaServer.Seasons
      |> where(id: ^id)
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
end
