defmodule MediaServerWeb.SubtitleMovieControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.Indexers.Movie

  test "movie", %{conn: conn} do
    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = get(conn, Routes.subtitle_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Caminandes Llama Drama.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end
end
