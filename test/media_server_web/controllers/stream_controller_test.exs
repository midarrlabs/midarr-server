defmodule MediaServerWeb.StreamControllerTest do
  use MediaServerWeb.ConnCase

  test "movie", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"]), token: MediaServer.Token.get_token())

    assert conn.status === 206
  end

  test "movie segment", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"], start: 5, end: 10), token: MediaServer.Token.get_token())

    assert conn.status === 200
  end

  test "movie halts with random token", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "movie halts without token", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    conn = get(conn, Routes.stream_path(conn, :index, movie: movie["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "episode", %{conn: conn} do
    series = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"], start: 5, end: 10), token: MediaServer.Token.get_token())

    assert conn.status === 200
  end

  test "episode segment", %{conn: conn} do
    series = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]), token: MediaServer.Token.get_token())

    assert conn.status === 206
  end

  test "episode halts with random token", %{conn: conn} do
    series = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "episode halts without token", %{conn: conn} do
    series = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(series["id"])

    conn = get(conn, Routes.stream_path(conn, :index, episode: episode["id"]))

    assert conn.status === 403
    assert conn.halted
  end
end
