defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  alias MediaServerWeb.Helpers
  alias MediaServer.Movies.Indexer

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    Helpers.send_video(conn, headers, Indexer.get_movie_path(id))
  end
end
