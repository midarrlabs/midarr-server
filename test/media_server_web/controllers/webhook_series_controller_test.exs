defmodule MediaServerWeb.Webhooks.SeriesControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.Token

  test "it should halt", %{conn: conn} do
    conn =
      post(conn, Routes.series_path(conn, :create, %{"someKey" => "someValue"}),
        token: "someToken"
      )

    assert conn.status === 403
    assert conn.halted
  end

  test "it should fall through", %{conn: conn} do
    conn =
      post(conn, Routes.series_path(conn, :create, %{"someKey" => "someValue"}),
        token: Token.get_token()
      )

    assert conn.status === 200
  end

  test "it should fall through again", %{conn: conn} do
    conn =
      post(conn, Routes.series_path(conn, :create, %{"eventType" => "someValue"}),
        token: Token.get_token()
      )

    assert conn.status === 200
  end

  test "it should create", %{conn: conn} do
    conn =
      post(conn, Routes.series_path(conn, :create, %{"eventType" => "Download"}),
        token: Token.get_token()
      )

    assert conn.status === 201
  end
end
