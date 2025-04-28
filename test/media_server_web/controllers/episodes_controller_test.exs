defmodule MediaServerWeb.EpisodesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it has episodes", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1/seasons/1/episodes?token=#{user.api_token.token}")

    [first | _] = json_response(conn, 200)["data"]

    assert is_binary(first["title"])
  end

  test "it has episode", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series/1/seasons/1/episodes/1?token=#{user.api_token.token}")

    result = json_response(conn, 200)

    assert is_binary(result["title"])
  end
end
