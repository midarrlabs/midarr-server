defmodule MediaServerWeb.SeriesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it has series", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_binary(first["title"])
  end

  test "it has serie", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1?token=#{user.api_token.token}")

    result = json_response(conn, 200)

    assert is_binary(result["title"])
  end
end
