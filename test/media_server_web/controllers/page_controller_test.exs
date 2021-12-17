defmodule MediaServerWeb.PageControllerTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures

  test "GET /", %{conn: conn} do
    email = unique_user_email()

    conn =
      post(conn, Routes.user_registration_path(conn, :create), %{
        "user" => valid_user_attributes(email: email)
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
