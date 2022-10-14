defmodule MediaServerWeb.StreamMovieControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.Indexers.Movie

  test "movie", %{conn: conn} do
    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-35103579/35103580"})
  end

  test "it halts with random token", %{conn: conn} do
    movie = Movie.get_movie("1")

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it halts without token", %{conn: conn} do
    movie = Movie.get_movie("1")

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "movie range", %{conn: conn} do
    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-35103579/35103580"})
  end

  test "safari probe", %{conn: conn} do
    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/35103580"})
  end
end
