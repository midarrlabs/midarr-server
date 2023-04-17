defmodule MediaServerWeb.HLSPlaylistController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{
      duration: movie["movieFile"]["mediaInfo"]["runTime"],
      url: Routes.stream_path(conn, :index, movie: id, token: MediaServer.Token.get_token())
    }))
  end

  def index(conn, %{"episode" => id}) do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(id)

    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{
      duration: episode["episodeFile"]["mediaInfo"]["runTime"],
      url: Routes.stream_path(conn, :index, episode: id, token: MediaServer.Token.get_token())
    }))
  end
end
