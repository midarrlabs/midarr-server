defmodule MediaServerWeb.WebhooksControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "movie should halt", %{conn: conn} do
    conn = post(conn, ~p"/api/webhooks/movie?token=someToken", %{"someKey" => "someValue"})

    assert conn.status === 403
    assert conn.halted
  end

  test "movie should fall through", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"someKey" => "someValue"})

    assert conn.status === 200
  end

  test "movie should fall through again", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "someValue"})

    assert conn.status === 200
  end

  test "it should add movie", %{conn: conn, user: user} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "movie")

    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "Download"})

    assert_received {:added}

    assert conn.status === 201
  end

  test "it should delete movie", %{conn: conn, user: user} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "movie")

    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "MovieDelete"})

    assert_received {:deleted}

    assert conn.status === 201
  end

  test "it should movie on file delete", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "MovieFileDelete"})

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
      post(
        conn,
        Routes.webhooks_path(conn, :create, "series", %{"eventType" => "EpisodeFileDelete"}),
        token: user.api_token.token
      )

    assert conn.status === 201
  end
end
