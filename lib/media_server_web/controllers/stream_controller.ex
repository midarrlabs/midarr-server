defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Episodes

  def show(%{req_headers: headers} = conn, %{"movie" => movie}) do
    send_video(conn, headers, Movies.get_movie_path(movie))
  end

  def show(%{req_headers: headers} = conn, %{"episode" => episode}) do
    send_video(conn, headers, Episodes.get_episode_path(episode))
  end

  defp get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_pos} ->
        String.split(start_pos, "-") |> hd |> String.to_integer
      nil ->
        0
    end
  end

  defp get_file_size(path) do
    {:ok, %{size: size}} = File.stat path

    size
  end
  
  defp send_video(conn, headers, path) do

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
        |> put_resp_header("content-range", "bytes #{offset}-#{file_size-1}/#{file_size}")
        |> send_file(206, path, offset, file_size - offset)
    end
  end
end