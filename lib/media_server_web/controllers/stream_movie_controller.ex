defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    Exstream.Range.get_video(conn, MediaServer.MoviesIndex.get_movie_path(id))
  end
end
