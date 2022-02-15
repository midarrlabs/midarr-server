defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  test "without integrations", %{conn: conn} do
    fixture = %{user: user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end

  test "with integrations", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      radarr: radarr_fixture(),
      sonarr: sonarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
