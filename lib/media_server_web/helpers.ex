defmodule MediaServerWeb.Helpers do

  import Plug.Conn

  def get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_pos} ->
        String.split(start_pos, "-") |> hd |> String.to_integer()

      nil ->
        0
    end
  end

  def get_file_size(path) do
    {:ok, %{size: size}} = File.stat(path)

    size
  end

  def send_video(conn, headers, path) do
    file_size = get_file_size(path)

    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=0-1"} ->
        conn
        |> put_resp_header("content-type", "video/mp4")
        |> put_resp_header("content-range", "bytes 0-1/#{file_size}")
        |> send_file(206, path, 0, 2)

      _ ->
        offset = get_offset(headers)

        conn
        |> put_resp_header("content-type", "video/mp4")
        |> put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
        |> send_file(206, path, offset, file_size - offset)
    end
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
end
