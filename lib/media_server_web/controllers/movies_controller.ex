defmodule MediaServerWeb.MoviesController do
  use MediaServerWeb, :controller

  def index(conn, params) do
    {:ok, {movies, meta}} = Flop.validate_and_run(MediaServer.Movies, params)

    conn
    |> json(%{
        data: movies,
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
    movie = MediaServer.Repo.get(MediaServer.Movies, id)

    conn
    |> json(movie)
  end
end
