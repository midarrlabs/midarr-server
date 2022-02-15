defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  defp create_fixtures(_) do
    %{user: user_fixture()}
  end

  describe "Show episode" do
    setup [:create_fixtures]

    test "watch", %{conn: conn, user: user} do

      {_sonarr, _series_id, episode_id} = sonarr_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/episodes/#{ episode_id }/watch")
      assert html_response(conn, 200)
    end
  end
end
