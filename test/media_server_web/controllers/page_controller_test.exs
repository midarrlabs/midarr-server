defmodule MediaServerWeb.PageControllerTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures

  test "GET /", %{conn: conn} do
    fixture = %{user: user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
