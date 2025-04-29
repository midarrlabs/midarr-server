defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: id)

    MediaServerWeb.Range.stream(%MediaServerWeb.Range{
      conn: conn,
      path: movie.path
    })
  end

  def index(conn, %{"episode" => id}) do
    MediaServerWeb.Range.stream(%MediaServerWeb.Range{
      conn: conn,
      path: MediaServer.SeriesIndex.get_episode_path(id)
    })
  end
end
