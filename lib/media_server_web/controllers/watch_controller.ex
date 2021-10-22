defmodule MediaServerWeb.WatchController do
  use MediaServerWeb, :controller

  import MediaServerWeb.Util

  def index(%{req_headers: headers} = conn, _params) do
    send_video(conn, headers, "./videos/video.mp4")
  end
end
