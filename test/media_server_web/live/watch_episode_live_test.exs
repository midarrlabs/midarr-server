defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    MediaServer.Actions.create(%{
      action: "some action"
    })

    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user)}
  end

  test "it should watch", %{conn: conn} do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(1)

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    render_hook(view, :video_played)

    assert Enum.count(MediaServer.MediaActions.all()) === 1
  end

  test "it should continue", %{conn: conn} do
    serie = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    render_hook(view, :video_destroyed, %{
      current_time: 39,
      duration: 78
    })

    assert MediaServer.Repo.all(MediaServer.Continues) |> List.first()

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"], timestamp: 39))

    assert render(view) =~ "#t=39"
  end

  test "it should subtitle", %{conn: conn} do
    serie = MediaServer.SeriesIndex.get_all() |> List.first()

    episode = MediaServerWeb.Repositories.Episodes.get_episode(serie["id"])

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    assert disconnected_html =~ Routes.subtitle_path(conn, :index, episode: episode["id"])
  end

  test "it should not subtitle", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: 3))

    refute disconnected_html =~ Routes.subtitle_path(conn, :index, episode: 3)
  end
end
