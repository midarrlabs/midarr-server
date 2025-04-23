defmodule MediaServerWeb.MoviesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "first movie has a title", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_binary(first["title"])
  end
end
