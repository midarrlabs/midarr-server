defmodule MediaServerWeb.StreamEpisodeControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures
  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  setup %{conn: conn} do
    %{conn: conn, user: AccountsFixtures.user_fixture()}
  end

  test "episode", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-47552616/47552617"})
  end

  test "it halts with random token", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: "someToken")

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

    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    Phoenix.Token.sign(conn, "user auth", user.id)

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "episode range", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-47552616/47552617"})
  end

  test "safari probe", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    assert get_session(conn, :user_token)
    assert redirected_to(conn) == "/"

    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(conn, "user auth", user.id)

    conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/47552617"})
  end
end
