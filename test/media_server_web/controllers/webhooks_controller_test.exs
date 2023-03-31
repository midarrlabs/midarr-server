defmodule MediaServerWeb.WebhooksControllerTest do
  use MediaServerWeb.ConnCase

  test "it should halt", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"someKey" => "someValue"}), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it should fall through", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"someKey" => "someValue"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 200
  end

  test "it should fall through again", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "someValue"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 200
  end

  test "it should create", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "Download"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end

  test "it should create on delete", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "MovieDelete"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end

  test "it should create on file delete", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "MovieFileDelete"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end

  test "series should halt", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"someKey" => "someValue"}),
        token: "someToken"
      )

    assert conn.status === 403
    assert conn.halted
  end

  test "series should fall through", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"someKey" => "someValue"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 200
  end

  test "series should fall through again", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "someValue"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 200
  end

  test "series should create", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "Download"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end

  test "series should create on delete", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "SeriesDelete"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end

  test "series should create on episode file delete", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "EpisodeFileDelete"}),
        token: MediaServer.Token.get_token()
      )

    assert conn.status === 201
  end
end
