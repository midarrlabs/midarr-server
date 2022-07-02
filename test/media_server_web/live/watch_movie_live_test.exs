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

  describe "Show page" do
    setup [:create_fixtures]

    test "it can watch", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :video_played)

      assert Enum.count(ActionsFixtures.get_movie_played()) === 1
    end

    test "it has continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, view, _html} = live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      render_hook(view, :video_destroyed, %{
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

      render_hook(view, :video_destroyed, %{
        current_time: 90,
        duration: 100
      })

      refute ContinuesFixtures.get_movie_continue()
    end

    test "it has subtitle", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie = MoviesFixtures.get_movie()

      {:ok, _view, disconnected_html} =
        live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"]))

      assert disconnected_html =~ Routes.subtitle_movie_path(conn, :show, movie["id"])
    end

    test "it does not have subtitle", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, _view, disconnected_html} = live(conn, Routes.watch_movie_show_path(conn, :show, 2))

      refute disconnected_html =~ Routes.subtitle_movie_path(conn, :show, 2)
    end
  end
end
