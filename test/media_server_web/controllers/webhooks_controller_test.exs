defmodule MediaServerWeb.WebhooksControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should halt", %{conn: conn} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"someKey" => "someValue"}), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it should fall through", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"someKey" => "someValue"}),
        token: user.api_token.token
      )

    assert conn.status === 200
  end

  test "it should fall through again", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "someValue"}),
        token: user.api_token.token
      )

    assert conn.status === 200
  end

  test "it should create", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "Download"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end

  test "it should create on delete", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "MovieDelete"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end

  test "it should create on file delete", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "movie", %{"eventType" => "MovieFileDelete"}),
        token: user.api_token.token
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

  test "series should fall through", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"someKey" => "someValue"}),
        token: user.api_token.token
      )

    assert conn.status === 200
  end

  test "series should fall through again", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "someValue"}),
        token: user.api_token.token
      )

    assert conn.status === 200
  end

  test "series should create", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "Download"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end

  test "series should create on delete", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "SeriesDelete"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end

  test "series should create on episode file delete", %{conn: conn, user: user} do
    conn =
      post(conn, Routes.webhooks_path(conn, :create, "series", %{"eventType" => "EpisodeFileDelete"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end
end
