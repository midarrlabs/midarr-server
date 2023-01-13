defmodule MediaServerWeb.SubtitleMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(
      200,
      Extitles.format(Extitles.parse(MediaServer.MoviesSubtitle.get_subtitle_path_for(id)))
    )
  end
end
