defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures

  test "with integrations", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
