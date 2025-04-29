defmodule MediaServerWeb.StreamControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: 1)

    %{user: MediaServer.AccountsFixtures.user_fixture(), movie: movie}
  end

  test "movie halts with random token", %{conn: conn, movie: movie} do

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie.id), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "movie halts without token", %{conn: conn, movie: movie} do

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie.id))

    assert conn.status === 403
    assert conn.halted
  end

  test "episode halts with random token", %{conn: conn} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServer.SeriesIndex.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "episode halts without token", %{conn: conn} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServer.SeriesIndex.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]))

    assert conn.status === 403
    assert conn.halted
  end
end
