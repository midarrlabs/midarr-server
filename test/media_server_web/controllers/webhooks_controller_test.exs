defmodule MediaServerWeb.WebhooksControllerTest do
  use MediaServerWeb.ConnCase

  @subscription "#{'{"endpoint":"http://localhost:8081/some-push-service","keys":{"p256dh":"BNcRdreALRFXTkOOUHK1EtK2wtaz5Ry4YfYCA_0QTpQtUbVlUls0VJXg7A8u-Ts1XbjhazAkj7I99e8QcYP7DkM=","auth":"tBHItJI5svbpez7KI4CCXg=="}}'}"

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

    {:ok, _struct} = MediaServer.MediaActions.create(%{
      media_id: 3,
      user_id: user.id,
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: MediaServer.MediaTypes.get_type_id("movie")
    })

    {:ok, _struct} = MediaServer.PushSubscriptions.create(%{
      user_id: user.id,
      push_subscription: @subscription
    })

    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "Download", "movie" => %{"id" => 3, "title" => "Some Movie"}})

    assert conn.status === 201
  end

  test "it should delete movie", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "MovieDelete"})

    assert conn.status === 201
  end

  test "it should delete movie file", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/movie?token=#{user.api_token.token}", %{"eventType" => "MovieFileDelete"})

    assert conn.status === 201
  end

  test "series should halt", %{conn: conn} do
    conn = post(conn, ~p"/api/webhooks/series?token=someToken", %{"someKey" => "someValue"})

    assert conn.status === 403
    assert conn.halted
  end

  test "series should fall through", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/series?token=#{user.api_token.token}", %{"someKey" => "someValue"})

    assert conn.status === 200
  end

  test "series should fall through again", %{conn: conn, user: user} do
    conn = post(conn, ~p"/api/webhooks/series?token=#{user.api_token.token}", %{"eventType" => "someValue"})

    assert conn.status === 200
  end

  test "it should add series", %{conn: conn, user: user} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "series")

    conn = post(conn, ~p"/api/webhooks/series?token=#{user.api_token.token}", %{"eventType" => "Download"})

    assert_received {:added}

    assert conn.status === 201
  end

  test "it should delete series", %{conn: conn, user: user} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "series")

    conn = post(conn, ~p"/api/webhooks/series?token=#{user.api_token.token}", %{"eventType" => "SeriesDelete"})

    assert_received {:deleted}

    assert conn.status === 201
  end

  test "series should create on episode file delete", %{conn: conn, user: user} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "series")

    conn = post(conn, ~p"/api/webhooks/series?token=#{user.api_token.token}", %{"eventType" => "EpisodeFileDelete"})

    assert_received {:deleted_episode_file}

    assert conn.status === 201
  end
end
