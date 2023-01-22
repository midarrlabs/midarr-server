defmodule MediaServerWeb.StreamVideo do
  import Plug.Conn

  def get_file_size(path) do
    {:ok, %{size: size}} = File.stat(path)

    size
  end

  def handle_range({"range", "bytes=0-1"}, conn, path) do
    file_size = get_file_size(path)

    conn
    |> put_resp_header("content-type", "video/mp4")
    |> put_resp_header("content-range", "bytes 0-1/#{file_size}")
    |> send_file(206, path, 0, 2)
  end

  def handle_range({"range", "bytes=" <> start_pos}, conn, path) do
    file_size = get_file_size(path)

    offset =
      String.split(start_pos, "-")
      |> hd
      |> String.to_integer()

    conn
    |> put_resp_header("content-type", "video/mp4")
    |> put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, offset, file_size - offset)
  end

  def handle_range(nil, conn, path) do
    file_size = get_file_size(path)

    conn
    |> put_resp_header("content-type", "video/mp4")
    |> put_resp_header("content-range", "bytes 0-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, 0, file_size - 0)
  end

  def send_video(conn, headers, path) do
    List.keyfind(headers, "range", 0)
    |> handle_range(conn, path)
  end

  def init(default), do: default

  def call(%Plug.Conn{req_headers: headers, params: %{"id" => id}} = conn, "movie") do
    send_video(conn, headers, MediaServer.MoviesIndex.get_movie_path(id))
  end

  def call(%Plug.Conn{req_headers: headers, params: %{"id" => id}} = conn, "episode") do
    send_video(conn, headers, MediaServerWeb.Repositories.Episodes.get_episode_path(id))
  end
end