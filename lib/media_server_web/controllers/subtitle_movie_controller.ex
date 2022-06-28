defmodule MediaServerWeb.SubtitleMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.Extitle

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Extitle.format(Extitle.parse(Movies.get_subtitle_path_for(id))))
  end
end
