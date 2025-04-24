defmodule MediaServerWeb.SeriesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "first series has a title", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_binary(first["title"])
  end
end
