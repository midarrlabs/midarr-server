defmodule MediaServerWeb.WatchLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.ProvidersFixtures

  defp create_fixtures(_) do
    real_radarr_fixture()
    real_sonarr_fixture()

    %{user: user_fixture()}
  end

  describe "Show movie" do
    setup [:create_fixtures]

    test "watch", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/movies/1/watch")
      assert html_response(conn, 200)
    end
  end

  describe "Show episode" do
    setup [:create_fixtures]

    test "watch", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/episodes/1/watch")
      assert html_response(conn, 200)
    end
  end
end
