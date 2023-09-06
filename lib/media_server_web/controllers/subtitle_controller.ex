defmodule MediaServerWeb.SubtitleController do
  use MediaServerWeb, :controller

  def index(conn, %{"movie" => id}) do
    conn
    |> send_resp(
      200,
      Extitles.format(Extitles.parse(MediaServer.MoviesSubtitle.get_subtitle_path_for(id)))
    )
  end

  def index(conn, %{"episode" => id}) do
    conn
    |> send_resp(
      200,
      Extitles.format(
        Extitles.parse(MediaServerWeb.Repositories.Episodes.get_subtitle_path_for(id))
      )
    )
  end
end
