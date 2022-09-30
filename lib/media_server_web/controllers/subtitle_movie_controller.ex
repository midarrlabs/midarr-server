defmodule MediaServerWeb.SubtitleMovieController do
  use MediaServerWeb, :controller

  alias MediaServer.Subtitles.Movie

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Extitles.format(Extitles.parse(Movie.get_subtitle_path_for(id))))
  end
end
