defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "segment" => segment}) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    playlist = :ets.lookup(:playlists_table, "movie-#{ movie["id"] }")
               |> List.first()
               |> elem(1)
               |> String.split

    {segment_duration, offset_duration} = HlsPlaylist.get_segment_offset(playlist, String.to_integer(segment))

    conn = conn |> send_chunked(200)

    Exile.stream!([
      "ffmpeg",
      "-ss", "#{ offset_duration }",
      "-copyts",
      "-t", "#{ segment_duration }",
      "-i", movie["movieFile"]["path"],
      "-c", "copy",
      "-f", "mpegts",
      "pipe:"
    ])
    |> Enum.reduce_while(conn, fn (chunk, conn) ->
      case Plug.Conn.chunk(conn, chunk) do
        {:ok, conn} ->
          {:cont, conn}
        {:error, :closed} ->
          {:halt, conn}
      end
    end)
  end

  def index(conn, %{"episode" => _id}) do
    conn
  end
end
