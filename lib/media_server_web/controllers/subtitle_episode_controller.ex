defmodule MediaServerWeb.SubtitleEpisodeController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Episodes

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Extitles.format(Extitles.parse(Episodes.get_subtitle_path_for(id))))
  end
end
