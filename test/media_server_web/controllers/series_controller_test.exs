defmodule MediaServerWeb.SeriesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should have all", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"items\":[{\"background\":\"/api/images?series=1&type=background\",\"id\":1,\"overview\":\"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.\",\"poster\":\"/api/images?series=1&type=poster\",\"stream\":\"/api/stream?series=1\",\"title\":\"Pioneer One\",\"year\":2010}],\"next_page\":\"/api/series?page=2\",\"prev_page\":\"/api/series?page=0\",\"total\":1}"
  end

  test "it should have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?page=1&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body === "{\"items\":[{\"background\":\"/api/images?series=1&type=background\",\"id\":1,\"overview\":\"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.\",\"poster\":\"/api/images?series=1&type=poster\",\"stream\":\"/api/stream?series=1\",\"title\":\"Pioneer One\",\"year\":2010}],\"next_page\":\"/api/series?page=2\",\"prev_page\":\"/api/series?page=0\",\"total\":1}"
  end

  test "it should NOT have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/series?page=2&token=#{user.api_token.token}")

    assert conn.status === 200

    assert conn.resp_body ===
             "{\"items\":[],\"next_page\":\"/api/series?page=3\",\"prev_page\":\"/api/series?page=1\",\"total\":1}"
  end
end
