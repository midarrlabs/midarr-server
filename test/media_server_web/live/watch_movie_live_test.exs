defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.ContinuesFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.ActionsFixtures

  defp create_fixtures(_) do
    ComponentsFixtures.action_fixture()
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Show movie" do
    setup [:create_fixtures]

    test "it can show page", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      conn = get(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))
      assert html_response(conn, 200)
      assert Enum.count(ActionsFixtures.get_movie_played()) === 1
    end

    test "it has continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :movie_destroyed, %{
        current_time: 89,
        duration: 100
      })

      assert ContinuesFixtures.get_movie_continue()
    end

    test "it does not have continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :movie_destroyed, %{
        current_time: 90,
        duration: 100
      })

      refute ContinuesFixtures.get_movie_continue()
    end
  end
end
