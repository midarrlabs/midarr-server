defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.ContinuesFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.ActionsFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Show movie" do
    setup [:create_fixtures]

    test "continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      conn = get(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))
      assert html_response(conn, 200)
    end

    test "has continue status", %{conn: conn, user: user} do
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

      assert ContinuesFixtures.get_movie_continue()
    end

    test "no continue status", %{conn: conn, user: user} do
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

      refute ContinuesFixtures.get_movie_continue()
    end

    test "it has played", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      ComponentsFixtures.action_fixture()

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :movie_played)

      assert ActionsFixtures.get_movie_played()
    end
  end
end
