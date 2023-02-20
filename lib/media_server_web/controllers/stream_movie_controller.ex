defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id, "segment" => segment}) do
    conn
    |> send_resp(200, Exstream.segment(MediaServer.MoviesIndex.get_movie_path(id), String.to_integer(segment)))
  end

  def show(conn, %{"id" => id}) do
    Exstream.Range.get_video(conn, MediaServer.MoviesIndex.get_movie_path(id))
  end
end
