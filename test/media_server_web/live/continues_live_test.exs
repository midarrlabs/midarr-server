defmodule MediaServerWeb.ContinuesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should render", %{conn: conn} do
    assert html_response(get(conn, Routes.continues_index_path(conn, :index)), 200)
  end

  test "it should delete", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    {:ok, index_live, _html} = live(conn, Routes.continues_index_path(conn, :index))

    assert index_live |> element("#continue-movie-#{movie["id"]}") |> render_click()
  end

  test "it has continues", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    another_movie = MediaServer.MoviesIndex.get_movie("2")

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_movie_show_path(conn, :show, another_movie["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 89,
      duration: 100
    })

    episode = MediaServerWeb.Repositories.Episodes.get_episode(1)

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 39,
      duration: 78
    })

    another_episode = MediaServerWeb.Repositories.Episodes.get_episode(2)

    {:ok, view, _disconnected_html} =
      live(conn, Routes.watch_episode_show_path(conn, :show, another_episode["id"], "watch"))

    render_hook(view, :video_destroyed, %{
      current_time: 39,
      duration: 78
    })

    {:ok, _view, disconnected_html} = live(conn, Routes.continues_index_path(conn, :index))

    assert disconnected_html =~ Routes.watch_movie_show_path(conn, :show, movie["id"], "continue")
    assert disconnected_html =~ Routes.watch_movie_show_path(conn, :show, another_movie["id"], "continue")
    assert disconnected_html =~ Routes.watch_episode_show_path(conn, :show, episode["id"], "continue")
    assert disconnected_html =~ Routes.watch_episode_show_path(conn, :show, another_episode["id"], "continue")
  end
end
