defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  alias MediaServer.Media
  
  def show(%{req_headers: headers} = conn, %{"id" => id}) do

    file = Media.get_file!(id)

    send_video(conn, headers, file.path)
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
    offset = get_offset(headers)
    file_size = get_file_size(path)

    conn
    |> Plug.Conn.put_resp_header("content-type", "video/mp4")
    |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size-1}/#{file_size}")
    |> Plug.Conn.send_file(206, path, offset, file_size - offset)
  end
end