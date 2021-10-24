defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  import MediaServerWeb.Util

  def index(%{req_headers: headers} = conn, %{"id" => id, "movie" => movie}) do

    send_video(conn, headers, "/movies/"<>URI.decode(id)<>"/"<>movie)
  end
end
