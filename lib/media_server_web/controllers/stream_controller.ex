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
      "-avoid_negative_ts", "disabled",
      "-t", "#{ segment_duration }",
      "-i", movie["movieFile"]["path"],
      "-c:v", "libx264",
      "-c:a", "aac",
      "-ac", "2",
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

  def index(conn, %{"episode" => id, "segment" => segment}) do

    episode_path = MediaServerWeb.Repositories.Episodes.get_episode_path(id)

    playlist = :ets.lookup(:playlists_table, "episode-#{ id }")
               |> List.first()
               |> elem(1)
               |> String.split

    {segment_duration, offset_duration} = HlsPlaylist.get_segment_offset(playlist, String.to_integer(segment))

    conn = conn |> send_chunked(200)

    Exile.stream!([
      "ffmpeg",
      "-ss", "#{ offset_duration }",
      "-copyts",
      "-avoid_negative_ts", "disabled",
      "-t", "#{ segment_duration }",
      "-i", episode_path,
      "-c:v", "libx264",
      "-c:a", "aac",
      "-ac", "2",
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
end
