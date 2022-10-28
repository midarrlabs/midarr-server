defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  setup %{conn: conn} do
    MediaServer.Actions.create(%{
      action: "some action"
    })

    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user)}
  end

  test "it should watch", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_played)

    assert Enum.count(MediaServer.MediaActions.all()) === 1
  end

  test "it should continue", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 39,
      duration: 78
    })

    assert MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "continue"))

    assert render(view) =~ "#t=39"
  end

  test "it should not continue", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 90,
      duration: 100
    })

    refute MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "continue"))

    refute render(view) =~ "#t=90"
  end

  test "it should subtitle", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    assert disconnected_html =~ Routes.subtitle_episode_path(conn, :show, episode["id"])
  end

  test "it should not subtitle", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, 3, "watch"))

    refute disconnected_html =~ Routes.subtitle_episode_path(conn, :show, 3)
  end
end
