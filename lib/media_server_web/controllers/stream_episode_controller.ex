defmodule MediaServerWeb.StreamEpisodeController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id, "segment" => segment}) do
    conn
    |> send_resp(200, Exstream.segment(MediaServerWeb.Repositories.Episodes.get_episode_path(id), String.to_integer(segment)))
  end

  def show(conn, %{"id" => id}) do
    Exstream.Range.get_video(conn, MediaServerWeb.Repositories.Episodes.get_episode_path(id))
  end
end
