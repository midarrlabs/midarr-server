defmodule MediaServerWeb.ImagesControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should get movie poster", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?movie=1&type=poster&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get movie background", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?movie=1&type=background&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get movie background with size", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?movie=1&type=background&size=w780&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get series poster", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?series=1&type=poster&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get series background", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?series=1&type=background&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get episode screenshot", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?episode=1&type=screenshot&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should NOT get episode screenshot", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?episode=10&type=screenshot&token=#{user.api_token.token}")

    assert conn.status === 404
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should get episode poster", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?episode=1&type=poster&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end

  test "it should NOT get episode poster", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/images?episode=10&type=poster&token=#{user.api_token.token}")

    assert conn.status === 404
    assert conn.state === :sent

    assert is_binary(conn.resp_body)
  end
end
