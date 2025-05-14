defmodule MediaServerWeb.SeriesController do
  use MediaServerWeb, :controller

  def index(conn, params) do
    {:ok, {series, meta}} = Flop.validate_and_run(MediaServer.Series, params)

    conn
    |> json(%{
        data: series,
        meta: %{
          total_pages: meta.total_pages,
          total_count: meta.total_count,
          has_next_page: meta.has_next_page?,
          has_previous_page: meta.has_previous_page?,
          previous_page: meta.previous_page,
          next_page: meta.next_page,
          current_page: meta.current_page,
        }
      })
  end

  def show(conn, %{"id" => id}) do
    series = MediaServer.Repo.get(MediaServer.Series, id)

    conn
    |> json(series)
  end
end
