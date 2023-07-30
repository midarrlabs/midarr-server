defmodule MediaServerWeb.SubtitleControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "movie", %{conn: conn, user: user} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "1")

    conn = get(conn, Routes.subtitle_path(conn, :index, movie: movie["id"]), token: user.api_token.token)

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Caminandes Llama Drama.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end

  test "episode", %{conn: conn, user: user} do
    serie = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(serie["id"])

    conn = get(conn, Routes.subtitle_path(conn, :index, episode: episode["id"]), token: user.api_token.token)

    assert conn.status === 200
    assert conn.state === :sent

    assert conn.resp_body ===
             "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Pioneer One Season 1 Episode 1.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
  end
end
