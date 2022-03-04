defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.WatchesFixtures

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

      conn = get(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))
      assert html_response(conn, 200)
    end

    test "has watch status", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :movie_destroyed, %{
        movie_id: movie["id"],
        current_time: 89,
        duration: 100,
        user_id: user.id
      })

      assert WatchesFixtures.get_movie_watch()
    end

    test "no watch status", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :movie_destroyed, %{
        movie_id: movie["id"],
        current_time: 90,
        duration: 100,
        user_id: user.id
      })

      refute WatchesFixtures.get_movie_watch()
    end
  end
end
