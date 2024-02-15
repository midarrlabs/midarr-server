defmodule MediaServerWeb.StreamControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "movie halts with random token", %{conn: conn} do
    movie = MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.find("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "movie halts without token", %{conn: conn} do
    movie = MediaServer.MoviesIndex.all() |> MediaServer.MoviesIndex.find("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "episode halts with random token", %{conn: conn} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "episode halts without token", %{conn: conn} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]))

    assert conn.status === 403
    assert conn.halted
  end
end
