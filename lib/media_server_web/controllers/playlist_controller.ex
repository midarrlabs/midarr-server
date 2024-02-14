defmodule MediaServerWeb.PlaylistController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "token" => token}) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    playlist = HlsPlaylist.get_segments(HlsPlaylist.get_keyframes(movie["movieFile"]["path"]), HlsPlaylist.get_duration(movie["movieFile"]["path"]))
               |> HlsPlaylist.get_playlist("/api/stream?movie=#{ movie["id"] }&token=#{ token }")

    :ets.insert_new(:playlists_table, {"movie-#{ movie["id"] }", playlist})

    conn
    |> send_resp(200, playlist)
  end
end
