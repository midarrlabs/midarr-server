defmodule MediaServerWeb.StreamMovieControllerTest do
  use MediaServerWeb.ConnCase

  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  defp create_fixtures(_) do
    %{user: user_fixture()}
  end

  describe "GET movie stream" do

    setup [:create_fixtures]

    test "movie", %{conn: conn, user: user} do

      {_radarr, movie_id} = real_radarr_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request
      conn = get(conn, "/movies/#{ movie_id }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-172478927/172478928"})
    end

    test "movie range", %{conn: conn, user: user} do

      {_radarr, movie_id} = real_radarr_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
      conn = get(conn, "/movies/#{ movie_id }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-172478927/172478928"})
    end

    test "safari probe", %{conn: conn, user: user} do

      {_radarr, movie_id} = real_radarr_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
      conn = get(conn, "/movies/#{ movie_id }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/172478928"})
    end
  end
end
