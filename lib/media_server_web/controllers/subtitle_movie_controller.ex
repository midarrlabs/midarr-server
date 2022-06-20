defmodule MediaServerWeb.SubtitleMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.Extitle

  def show(%{req_headers: headers} = conn, %{"id" => movie_id}) do
    conn
    |> send_resp(200, Extitle.format(Extitle.parse(Movies.get_subtitle_path_for(movie_id))))
  end
end
