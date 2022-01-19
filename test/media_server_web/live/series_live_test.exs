defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  test "GET /series", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      sonarr: real_sonarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/series")
    assert html_response(conn, 200)
  end

  test "GET /series show", %{conn: conn} do
    fixture = %{
      user: user_fixture()
    }

    {_sonarr, series_id, _episode_id} = real_sonarr_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/series/#{ series_id }")
    assert html_response(conn, 200)
  end
end
