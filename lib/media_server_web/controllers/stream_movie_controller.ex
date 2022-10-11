defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Helpers
  alias MediaServer.Indexers.Movie

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    Helpers.send_video(conn, headers, Movie.get_movie_path(id))
  end
end
