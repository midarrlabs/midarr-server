defmodule MediaServerWeb.SubtitleEpisodeControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServer.EpisodesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "GET episode subtitle" do
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

      token = Phoenix.Token.sign(conn, "user auth", user.id)

      conn = get(conn, Routes.subtitle_episode_path(conn, :show, episode["id"]), token: token)

      assert conn.status === 200
      assert conn.state === :sent
      assert conn.resp_body === "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of\na subtitle.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of\na subtitle - 2nd subtitle."
    end
  end
end
