defmodule MediaServerWeb.SubtitleEpisodeController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Extitle

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Extitle.format(Extitle.parse(Episodes.get_subtitle_path_for(id))))
  end
end
