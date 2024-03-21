defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id, "segment" => segment}) do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), id)

    {segment_duration, offset_duration} = HlsPlaylist.Segments.generate(HlsPlaylist.get_duration(movie["movieFile"]["path"]))
    |> HlsPlaylist.get_segment_offset(String.to_integer(segment))

    conn = conn |> send_chunked(200)

    Exile.stream!([
      "ffmpeg",
      "-vaapi_device", "/dev/dri/renderD128",
      "-ss", "#{ offset_duration }",
      "-copyts",
      "-avoid_negative_ts", "disabled",
      "-t", "#{ segment_duration }",
      "-i", movie["movieFile"]["path"],
      "-vf", "format=nv12,hwupload",
      "-c:v", "h264_vaapi",
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

    {segment_duration, offset_duration} = HlsPlaylist.Segments.generate(HlsPlaylist.get_duration(episode_path))
    |> HlsPlaylist.get_segment_offset(String.to_integer(segment))

    conn = conn |> send_chunked(200)

    Exile.stream!([
      "ffmpeg",
      "-vaapi_device", "/dev/dri/renderD128",
      "-ss", "#{ offset_duration }",
      "-copyts",
      "-avoid_negative_ts", "disabled",
      "-t", "#{ segment_duration }",
      "-i", episode_path,
      "-vf", "format=nv12,hwupload",
      "-c:v", "h264_vaapi",
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
