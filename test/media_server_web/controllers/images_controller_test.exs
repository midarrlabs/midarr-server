defmodule MediaServerWeb.ImagesControllerTest do
  use MediaServerWeb.ConnCase

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should get url", %{conn: conn, user: user} do

    url = "#{System.get_env("RADARR_BASE_URL")}/api/v3/mediacover/3/poster.jpg?apiKey=#{System.get_env("RADARR_API_KEY")}"

    conn = get(conn, ~p"/api/images?url=#{url}&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.state === :sent

    assert get_resp_header(conn, "content-type") == ["image/image"]
    assert get_resp_header(conn, "cache-control") == ["max-age=604800, public, must-revalidate"]

    assert is_binary(conn.resp_body)
  end
end
