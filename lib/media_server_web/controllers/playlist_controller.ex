defmodule MediaServerWeb.PlaylistController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    path = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)["movieFile"]["path"]

    playlist = HlsPlaylist.get_playlist(HlsPlaylist.get_segments(HlsPlaylist.get_keyframes(path), HlsPlaylist.get_duration(path), 3), "segment")

    conn
    |> send_resp(200, playlist)
  end
end
