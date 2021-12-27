defmodule MediaServerWeb.StreamControllerTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.ProvidersFixtures

  setup do
    %{
      user: user_fixture(),
      radarr: real_radarr_fixture(),
      sonarr: real_sonarr_fixture()
    }
  end

  describe "GET movie" do

    test "gets stream", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request
      conn = get(conn, "/movies/1/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-133/134"})
    end
  end

  describe "GET episode" do

    test "gets stream", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request
      conn = get(conn, "/episodes/12/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-199383018/199383019"})
    end
  end
end
