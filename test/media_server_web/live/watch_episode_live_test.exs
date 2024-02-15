defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture())}
  end

  test "it should watch", %{conn: conn} do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(1)

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    render_hook(view, :video_played)

    media = MediaServer.MediaActions.where(media_id: episode["id"])

    assert media.media_id === episode["id"]
    assert media.action_id === MediaServer.Actions.get_played_id()
  end

  test "it should continue", %{conn: conn} do
    serie = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    refute MediaServer.Continues.where(media_id: episode["id"]) === episode["id"]

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"], timestamp: 39))

    assert render(view) =~ "39"
  end

  test "it should not subtitle", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: 3))

    refute disconnected_html =~ Routes.subtitle_path(conn, :index, episode: 3)
  end

  test "it should not have navigation", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: 3))

    refute disconnected_html =~ "mobile-menu"
  end
end
