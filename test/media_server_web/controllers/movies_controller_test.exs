defmodule MediaServerWeb.MoviesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should have all", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === Jason.encode!(MediaServer.MoviesIndex.all())
  end
end
