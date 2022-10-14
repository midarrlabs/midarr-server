defmodule MediaServerWeb.StreamEpisodeControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  test "episode", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-47552616/47552617"})
  end

  test "it halts with random token", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it halts without token", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]))

    assert conn.status === 403
    assert conn.halted
  end

  test "episode range", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-47552616/47552617"})
  end

  test "safari probe", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    token = Phoenix.Token.sign(MediaServerWeb.Endpoint, "user auth", "id")

    conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
    conn = get(conn, Routes.stream_episode_path(conn, :show, episode["id"]), token: token)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/47552617"})
  end
end
