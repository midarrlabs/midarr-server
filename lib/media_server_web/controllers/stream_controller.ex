defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    Exstream.Range.stream(%Exstream.Range{
      conn: conn,
      path: MediaServer.MoviesIndex.get_movie_path(id)
    })
  end

  def index(conn, %{"episode" => id}) do
    Exstream.Range.stream(%Exstream.Range{
      conn: conn,
      path: MediaServerWeb.Repositories.Episodes.get_episode_path(id)
    })
  end
end
