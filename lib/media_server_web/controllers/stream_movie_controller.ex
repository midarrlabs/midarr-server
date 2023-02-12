defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    MediaServerWeb.Helpers.send_video(conn, headers, MediaServer.MoviesIndex.get_movie_path(id))
  end
end
