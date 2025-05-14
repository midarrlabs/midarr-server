defmodule MediaServerWeb.SearchController do
  use MediaServerWeb, :controller

  import Ecto.Query

  def index(conn, %{"query" => query} = params) do
    movies_query = MediaServer.Movies |> where([m], ilike(m.title, ^"%#{query}%"))
    series_query = MediaServer.Series |> where([s], ilike(s.title, ^"%#{query}%"))

    {:ok, {movies, movies_meta}} = Flop.validate_and_run(movies_query, params)
    {:ok, {series, series_meta}} = Flop.validate_and_run(series_query, params)

    conn
    |> json(%{
      data: %{
        movies: movies,
        series: series,
      },
      meta: %{
        movies: %{
          total_pages: movies_meta.total_pages,
          total_count: movies_meta.total_count,
          has_next_page: movies_meta.has_next_page?,
          has_previous_page: movies_meta.has_previous_page?,
          previous_page: movies_meta.previous_page,
          next_page: movies_meta.next_page,
          current_page: movies_meta.current_page
        },
        series: %{
          total_pages: series_meta.total_pages,
          total_count: series_meta.total_count,
          has_next_page: series_meta.has_next_page?,
          has_previous_page: series_meta.has_previous_page?,
          previous_page: series_meta.previous_page,
          next_page: series_meta.next_page,
          current_page: series_meta.current_page
        }
      }
    })
  end
end
