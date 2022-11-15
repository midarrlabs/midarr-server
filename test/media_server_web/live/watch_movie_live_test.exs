defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should watch", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_played)

    assert Enum.count(MediaServer.MediaActions.all()) === 1
  end

  test "it should have 1 movie entry in media", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    MediaServer.Media.create(%{
      media_id: movie["id"],
      media_type_id: MediaServer.MediaTypes.get_id("movie")
    })

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    assert MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "continue"))

    assert render(view) =~ "#t=89"
    assert Enum.count(MediaServer.Media.all()) === 1
  end

  test "it should continue", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    assert MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "continue"))

    assert render(view) =~ "#t=89"
  end

  test "it should not continue", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 90,
      duration: 100
    })

    refute MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "continue"))

    refute render(view) =~ "#t=90"
  end

  test "it should subtitle", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

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
