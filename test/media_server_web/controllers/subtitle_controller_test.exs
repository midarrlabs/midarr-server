defmodule MediaServerWeb.SubtitleControllerTest do
  use MediaServerWeb.ConnCase

  test "movie", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    conn = get(conn, Routes.subtitle_path(conn, :index, movie: movie["id"]), token: MediaServer.Token.get_token())

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Caminandes Llama Drama.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end

  test "episode", %{conn: conn} do
    serie = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(serie["id"])

    conn = get(conn, Routes.subtitle_path(conn, :index, episode: episode["id"]), token: MediaServer.Token.get_token())

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Pioneer One Season 1 Episode 1.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end
end
