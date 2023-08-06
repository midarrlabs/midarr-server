defmodule MediaServerWeb.VerifyTokenTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should be valid", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    assert conn.status == 200
  end

  test "it should be invalid", %{conn: conn} do
    conn = get(conn, ~p"/api/movies?token=invalid-token")

    assert conn.status == 403
    assert conn.resp_body == "Forbidden"
  end
end
