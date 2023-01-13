defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Helpers

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    Helpers.send_video(conn, headers, MediaServer.MoviesIndex.get_movie_path(id))
  end
end
