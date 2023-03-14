defmodule MediaServerWeb.ImagesControllerTest do
  use MediaServerWeb.ConnCase

  setup %{conn: conn} do
    user = MediaServer.AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should get movie poster", %{conn: conn} do
    conn = get(conn, Routes.images_path(conn, :index), movie: "1", type: "poster")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get movie background", %{conn: conn} do
    conn = get(conn, Routes.images_path(conn, :index), movie: "1", type: "background")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get series poster", %{conn: conn} do
    conn = get(conn, Routes.images_path(conn, :index), series: "1", type: "poster")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get series background", %{conn: conn} do
    conn = get(conn, Routes.images_path(conn, :index), series: "1", type: "background")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end
end
