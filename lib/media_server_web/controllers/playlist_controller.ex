defmodule MediaServerWeb.PlaylistController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "token" => token}) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    playlist = HlsPlaylist.Segments.generate(HlsPlaylist.get_duration(movie["movieFile"]["path"]))
    |> HlsPlaylist.get_playlist("/api/stream?movie=#{ movie["id"] }&token=#{ token }")

    conn
    |> send_resp(200, playlist)
  end

  def index(conn, %{"episode" => id, "token" => token}) do
    episode_path = MediaServerWeb.Repositories.Episodes.get_episode_path(id)

    playlist = HlsPlaylist.Segments.generate(HlsPlaylist.get_duration(episode_path))
    |> HlsPlaylist.get_playlist("/api/stream?episode=#{ id }&token=#{ token }")

    conn
    |> send_resp(200, playlist)
  end
end
