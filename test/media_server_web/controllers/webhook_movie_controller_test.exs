defmodule MediaServerWeb.Webhooks.MovieControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.Api.Token

  test "it should halt", %{conn: conn} do
    conn = post(conn, Routes.movie_path(conn, :create, %{"someKey" => "someValue"}), token: "someToken")

    assert conn.status === 403
    assert conn.halted
  end

  test "it should fall through", %{conn: conn} do
    conn = post(conn, Routes.movie_path(conn, :create, %{"someKey" => "someValue"}), token: Token.get_token())

    assert conn.status === 200
  end
end
