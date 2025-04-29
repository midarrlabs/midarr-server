defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ecto.Query

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture())}
  end

  test "it should continue", %{conn: conn} do
    serie = MediaServer.SeriesIndex.all() |> List.first()

    episode = MediaServer.SeriesIndex.get_episode(serie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"]))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    query =
      from m in MediaServer.Episodes,
        where: m.sonarr_id == ^episode["id"]

    result = MediaServer.Repo.one(query)

    refute MediaServer.EpisodeContinues.where(episodes_id: result.id) === episode["id"]

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"], timestamp: 39))

    assert render(view) =~ "39"
  end

  test "it should not have navigation", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: 3))

    refute disconnected_html =~ "mobile-menu"
  end
end
