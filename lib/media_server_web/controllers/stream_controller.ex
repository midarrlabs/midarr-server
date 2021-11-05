defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  import MediaServerWeb.Util

  alias MediaServer.Media
  alias MediaServer.Media.Stream

  def show(%{req_headers: headers} = conn, %{"id" => id}) do

    # file = Media.get_file!(id)

    {:ok, pid} = Stream.start_link("/app/samples/test-video.h264")

    Stream.play(pid)
    # |> then(&Process.monitor/1)

    json(conn, %{id: id})
  end
end