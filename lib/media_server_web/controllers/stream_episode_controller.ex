defmodule MediaServerWeb.StreamEpisodeController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    Exstream.Range.get_video(conn, MediaServerWeb.Repositories.Episodes.get_episode_path(id))
  end
end
