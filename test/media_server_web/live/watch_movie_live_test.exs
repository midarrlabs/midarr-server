defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.ProvidersFixtures

  defp create_fixtures(_) do
    %{user: user_fixture()}
  end

  describe "Show movie" do
    setup [:create_fixtures]

    test "watch", %{conn: conn, user: user} do

      {_radarr, movie_id} = real_radarr_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      conn = get(conn, "/movies/#{ movie_id }/watch")
      assert html_response(conn, 200)
    end
  end
end
