defmodule MediaServerWeb.StreamEpisodeController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id, "start" => start, "end" => finish}) do

    Exstream.stream(%Exstream{
      conn: conn,
      path: MediaServerWeb.Repositories.Episodes.get_episode_path(id),
      start: start,
      end: finish
    })
  end

  def show(conn, %{"id" => id}) do
    Exstream.Range.stream(%Exstream.Range{
      conn: conn,
      path: MediaServerWeb.Repositories.Episodes.get_episode_path(id)
    })
  end
end
