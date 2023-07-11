defmodule MediaServerWeb.OauthControllerTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "it should redirect", %{conn: conn} do
    conn = get(conn, Routes.o_auth_path(conn, :index))
    response = html_response(conn, 302)

    assert response =~ "You are being"
    assert response =~ "redirected"
    assert response =~ "authorize?client_id="
  end

  test "it should callback", %{conn: conn} do
    conn = get(conn, Routes.o_auth_path(conn, :callback, code: "code"))
    response = html_response(conn, 302)

    assert response =~ "You are being"
    assert response =~ "redirected"
  end
end
