defmodule MediaServerWeb.PlaylistEpisodeController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{
      duration: episode["episodeFile"]["mediaInfo"]["runTime"],
      url: Routes.stream_episode_path(conn, :show, id, token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", 1))
    }))
  end
end
