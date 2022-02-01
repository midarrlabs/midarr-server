defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  test "it without integrations", %{conn: conn} do
    fixture = %{user: user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end

  test "it with integrations", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      radarr: real_radarr_fixture(),
      sonarr: real_sonarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
