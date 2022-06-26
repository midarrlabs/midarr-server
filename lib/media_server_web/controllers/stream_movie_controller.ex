defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Helpers

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    Helpers.send_video(conn, headers, Movies.get_movie_path(id))
  end
end
