defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  alias MediaServer.Media

  def show(%{req_headers: headers} = conn, %{"id" => id}) do

    file = Media.get_file!(id)

    uuid = Ecto.UUID.generate

    # task = Task.async(fn ->
    #   Rambo.run(System.find_executable("ffmpeg"), ["-re", "-i", "#{file.path}", "-c", "copy", "-f", "rtsp", "rtsp://rtsp-simple-server:8554/#{uuid}"])
    # end)

    conn
    |> put_root_layout(false)
    |> assign(:file, file)
    |> assign(:uuid, uuid)
    |> render(:show)
  end

  
end

    # if !File.exists?("/app/priv/static/assets/output/#{id}.m3u8") do
    #   Task.async(fn ->
    #     Rambo.run(System.find_executable("ffmpeg"), ["-i", "#{file.path}", "-hls_time", "9", "-hls_flags", "single_file", "/app/priv/static/assets/output/#{id}.m3u8"])
    #   end)
    # end

    # result = retry with: constant_backoff(1000) |> Stream.take(10) do

    #   if File.exists?("/app/priv/static/assets/output/#{id}.m3u8") do
    #     :ok
    #   else
    #     :error
    #   end

    # after
    #   result -> conn
    #             |> put_root_layout(false)
    #             |> assign(:file, file)
    #             |> render(:show)
    # else
    #   error -> json(conn, "Oops no video, please try again")
    # end