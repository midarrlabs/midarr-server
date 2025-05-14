defmodule MediaServerWeb.MoviesControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it has movies", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_binary(first["title"])
  end

  test "it has movie", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies/1?token=#{user.api_token.token}")

    result = json_response(conn, 200)

    assert is_binary(result["title"])
  end
end
