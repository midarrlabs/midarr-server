defmodule MediaServerWeb.WatchMovieLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture())}
  end

  test "it should have played", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"]))

    render_hook(view, :video_played)
    render_hook(view, :video_played)

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 1

    assert Enum.at(media, 0).media_id === movie["id"]
    assert Enum.at(media, 0).action_id === MediaServer.Actions.get_played_id()
  end

  test "it should continue", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"]))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    assert MediaServer.MediaContinues.where(media_id: movie["id"]).current_time === 89

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"], timestamp: 89))

    assert render(view) =~ "89"

    render_hook(view, :video_destroyed, %{
      current_time: 45,
      duration: 100
    })

    assert MediaServer.MediaContinues.where(media_id: movie["id"]).current_time === 45
  end

  test "it should not subtitle", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "2")

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"]))

    refute disconnected_html =~ Routes.subtitle_path(conn, :index, movie: 2)
  end

  test "it should not have navigation", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "2")

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"]))

    refute disconnected_html =~ "mobile-menu"
  end
end
