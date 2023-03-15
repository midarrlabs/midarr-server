defmodule MediaServerWeb.PlaylistMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{
      duration: movie["movieFile"]["mediaInfo"]["runTime"],
      url: Routes.stream_movie_path(conn, :show, id, token: Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", 1))
    }))
  end
end
