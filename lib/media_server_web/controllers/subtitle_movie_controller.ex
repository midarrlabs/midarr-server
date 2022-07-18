defmodule MediaServerWeb.SubtitleMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Movies

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Extitles.format(Extitles.parse(Movies.get_subtitle_path_for(id))))
  end
end
