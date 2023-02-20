defmodule MediaServerWeb.PlaylistEpisodeController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Exstream.Playlist.build(MediaServerWeb.Repositories.Episodes.get_episode_path(id), Routes.stream_episode_path(conn, :show, id, token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", 1))))
  end
end
