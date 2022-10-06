defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.ContinuesFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.Actions

  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  setup %{conn: conn} do
    ComponentsFixtures.action_fixture()

    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should watch", %{conn: conn} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_played)

    assert Enum.count(Actions.list_episode_actions()) === 1
  end

  test "it should continue", %{conn: conn, user: user} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      episode_id: episode["id"],
      serie_id: episode["seriesId"],
      current_time: 39,
      duration: 78,
      user_id: user.id
    })

    assert ContinuesFixtures.get_episode_continue()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "continue"))

    assert render(view) =~ "#t=39"
  end

  test "it should not continue", %{conn: conn, user: user} do
    serie = Series.get_all() |> List.first()

    episode = Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      episode_id: episode["id"],
      serie_id: episode["seriesId"],
      current_time: 90,
      duration: 100,
      user_id: user.id
    })

    refute ContinuesFixtures.get_episode_continue()

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
