defmodule MediaServerWeb.Helpers do
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

  def minutes_remaining_from_seconds(duration, current_time) do
    ceil((duration - current_time) / 60)
  end

  def percentage_complete_from_seconds(current_time, duration) do
    current_time / duration * 100
  end

  def get_pagination_previous_link(page_number) do
    page_number - 1
  end

  def get_pagination_next_link(page_number) do
    page_number + 1
  end

  def reduce_size_for_poster_url(url) do
    String.replace(url, "original", "w342")
  end

  def get_subtitle(path) do
    File.ls!(path)
    |> Enum.filter(fn item -> String.contains?(item, ".srt") end)
    |> List.first()
  end
end
