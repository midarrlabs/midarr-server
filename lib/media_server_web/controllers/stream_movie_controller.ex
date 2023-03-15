defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id, "start" => start, "end" => finish}) do

    Exstream.stream(%Exstream{
      conn: conn,
      path: MediaServer.MoviesIndex.get_movie_path(id),
      start: start,
      end: finish
    })
  end

  def show(conn, %{"id" => id}) do
    Exstream.Range.stream(%Exstream.Range{
      conn: conn,
      path: MediaServer.MoviesIndex.get_movie_path(id)
    })
  end
end
