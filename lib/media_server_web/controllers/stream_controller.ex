defmodule MediaServerWeb.StreamController do
  use MediaServerWeb, :controller

  import MediaServerWeb.Util

  alias MediaServer.Media

  def show(%{req_headers: headers} = conn, %{"id" => id}) do

    file = Media.get_file!(id)

    send_video(conn, headers, file.path)
  end
end