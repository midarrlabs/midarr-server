defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.WatchStatusesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Show movie" do
    setup [:create_fixtures]

    test "watch", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      conn = get(conn, "/movies/#{ movie["id"] }/watch")
      assert html_response(conn, 200)
    end

    test "it has watch status", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, "/movies/#{ movie["id"] }/watch")

      render_hook(view, :video_destroyed, %{
        movie_id: movie["id"],
        timestamp: 39,
        user_id: user.id
      })

      assert WatchStatusesFixtures.get_watch_status()
    end
  end
end
