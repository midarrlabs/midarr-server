defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.ContinuesFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.ActionsFixtures

  alias MediaServer.Indexers.Movie

  setup %{conn: conn} do
    ComponentsFixtures.action_fixture()

    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user)}
  end

  test "it should watch", %{conn: conn} do
    movie = Movie.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_played)

    assert Enum.count(ActionsFixtures.get_movie_played()) === 1
  end

  test "it should continue", %{conn: conn} do
    movie = Movie.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    assert ContinuesFixtures.get_movie_continue()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "continue"))

    assert render(view) =~ "#t=89"
  end

  test "it should not continue", %{conn: conn} do
    movie = Movie.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 90,
      duration: 100
    })

    refute ContinuesFixtures.get_movie_continue()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "continue"))

    refute render(view) =~ "#t=90"
  end

  test "it should subtitle", %{conn: conn} do
    movie = Movie.get_movie("1")

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    assert disconnected_html =~ Routes.subtitle_movie_path(conn, :show, movie["id"])
  end

  test "it should not subtitle", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, 2, "watch"))

    refute disconnected_html =~ Routes.subtitle_movie_path(conn, :show, 2)
  end
end
