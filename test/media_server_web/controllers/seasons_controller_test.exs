defmodule MediaServerWeb.SeasonsControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "first seasons has a number", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1/seasons?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_integer(first["number"])
  end
end
