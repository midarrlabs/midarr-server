defmodule MediaServerWeb.StreamMovieController do
  use MediaServerWeb, :controller

  plug MediaServerWeb.StreamVideo, "movie"

  def show(conn, _params) do
    conn
  end
end
