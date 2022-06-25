defmodule MediaServerWeb.SubtitleMovieControllerTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "GET movie subtitle" do
    setup [:create_fixtures]

    test "movie", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == "/"

      movie = MoviesFixtures.get_movie()

      token = Phoenix.Token.sign(conn, "user auth", user.id)

      conn = get(conn, Routes.subtitle_movie_path(conn, :show, movie["id"]), token: token)

      assert conn.status === 200
      assert conn.state === :sent
      assert conn.resp_body === "WEBVTT\n\n00:01:00.400 --> 00:01:15.300\nThis is an example of a subtitle for Caminandes Llama Drama.\n\n00:01:16.400 --> 00:01:25.300\nThis is an example of a subtitle\nwith multiple lines."
    end
  end
end
