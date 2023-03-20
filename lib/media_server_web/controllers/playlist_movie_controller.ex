defmodule MediaServerWeb.PlaylistMovieController do
  use MediaServerWeb, :controller

  def show(conn, %{"id" => id}) do
    movie = MediaServer.MoviesIndex.get_movie(id)

    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{
      duration: movie["movieFile"]["mediaInfo"]["runTime"],
      url: Routes.stream_path(conn, :index, movie: id, token: MediaServer.Token.get_token())
    }))
  end
end
