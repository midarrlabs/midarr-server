defmodule MediaServerWeb.Onlin3Test do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  setup do
    %{
      user: user_fixture(),
      radarr: real_radarr_fixture(),
      sonarr: real_sonarr_fixture()
    }
  end

  describe "check online access" do
    test "it should not have access", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/")
      response = html_response(conn, 200)
      refute response =~ "<span>Online</span>"
      refute response =~ "Users</div>"
    end
  end
end
