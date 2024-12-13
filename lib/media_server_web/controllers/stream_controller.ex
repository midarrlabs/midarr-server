defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    MediaServerWeb.Range.stream(%MediaServerWeb.Range{
      conn: conn,
      path: MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)["movieFile"]["path"]
    })
  end

  def index(conn, %{"episode" => id}) do
    MediaServerWeb.Range.stream(%MediaServerWeb.Range{
      conn: conn,
      path: MediaServerWeb.Repositories.Episodes.get_episode_path(id)
    })
  end
end
