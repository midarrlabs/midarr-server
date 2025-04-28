defmodule MediaServerWeb.SeasonsControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it has seasons", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1/seasons?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_integer(first["number"])
  end

  test "it has season", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1/seasons/1?token=#{user.api_token.token}")

    result = json_response(conn, 200)

    assert is_integer(result["number"])
  end
end
