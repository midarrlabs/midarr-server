defmodule MediaServerWeb.WatchLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.ProvidersFixtures

  defp create_fixtures(_) do
    %{user: user_fixture(), radarr: real_radarr_fixture(), sonarr: real_sonarr_fixture()}
  end

  describe "Index" do
    setup [:create_fixtures]

    test "GET movies", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/movies/1/watch")
      assert html_response(conn, 200)
    end

    test "GET episodes", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/episodes/1/watch")
      assert html_response(conn, 200)
    end
  end
end
