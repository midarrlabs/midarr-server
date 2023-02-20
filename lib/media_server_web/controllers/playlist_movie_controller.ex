defmodule MediaServerWeb.PlaylistMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> send_resp(200, Exstream.Playlist.build(MediaServer.MoviesIndex.get_movie_path(id), Routes.stream_movie_path(conn, :show, id, token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", 1))))
  end
end
