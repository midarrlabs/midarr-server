defmodule MediaServerWeb.MoviesControllerTest do
  use MediaServerWeb.ConnCase

  use Plug.Test

  setup do
    %{user: MediaServer.AccountsFixtures.user_fixture()}
  end

  test "it should have all", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end

  test "it should have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?page=1&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end

  test "it should NOT have all paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?page=2&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[]}"
  end

  test "it should have genre", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=animation&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end

  test "it should NOT have genre", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=history&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[]}"
  end

  test "it should have genre paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=animation&page=1&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end

  test "it should NOT have genre paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?genre=history&page=1&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[]}"
  end

  test "it should sort by latest", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?sort_by=latest&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end

  test "it should sort by latest paged", %{conn: conn, user: user} do
    conn = get(conn, ~p"/api/movies?sort_by=latest&page=1&token=#{user.api_token.token}")

    assert conn.status === 200
    assert conn.resp_body === "{\"entries\":[{\"title\":\"Caminandes:  Llamigos\"},{\"title\":\"Caminandes: Gran Dillama\"},{\"title\":\"Caminandes: Llama Drama\"}]}"
  end
end
