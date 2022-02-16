defmodule MediaServerWeb.StreamEpisodeControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServer.EpisodesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "GET episode stream" do

    setup [:create_fixtures]

    test "episode", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      conn = get(conn, "/episodes/#{ episode["id"] }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-199383018/199383019"})
    end

    test "episode range", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      conn = conn |> recycle() |> put_req_header("range", "bytes=124-")
      conn = get(conn, "/episodes/#{ episode["id"] }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-199383018/199383019"})
    end

    test "safari probe", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      conn = conn |> recycle() |> put_req_header("range", "bytes=0-1")
      conn = get(conn, "/episodes/#{ episode["id"] }/stream")

      assert conn.status === 206
      assert conn.state === :file
      assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
      assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/199383019"})
    end
  end
end
