defmodule MediaServerWeb.StreamMovieControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures

  alias MediaServer.Indexers.Movie

  setup %{conn: conn} do
    %{conn: conn, user: AccountsFixtures.user_fixture()}
  end

  test "movie", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-35103579/35103580"})
  end

  test "it halts with random token", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    movie = Movie.get_movie("1")

    Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it halts without token", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    movie = Movie.get_movie("1")

    Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "movie range", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-35103579/35103580"})
  end

  test "safari probe", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    movie = Movie.get_movie("1")

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
    conn = get(conn, Routes.stream_movie_path(conn, :show, movie["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/35103580"})
  end
end
