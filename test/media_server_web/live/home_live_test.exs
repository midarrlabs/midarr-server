defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it has latest movies", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "Caminandes: Llama Drama"
    assert disconnected_html =~ "Caminandes: Gran Dillama"
    refute disconnected_html =~ "Caminandes: Llamigos"
  end

  test "it has latest series", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert render(view) =~ "Pioneer One"
  end

  test "it can search", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    {:ok, _, disconnected_html} =
      view
      |> form("#search", search: %{query: "Some query"})
      |> render_submit()
      |> follow_redirect(conn, Routes.search_index_path(conn, :index, query: "Some query"))

    assert disconnected_html =~ "Some query"
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

    {:ok, _view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ Routes.watch_movie_show_path(conn, :show, movie["id"], "continue")

    assert disconnected_html =~
             Routes.watch_movie_show_path(conn, :show, another_movie["id"], "continue")

    assert disconnected_html =~
             Routes.watch_episode_show_path(conn, :show, episode["id"], "continue")

    assert disconnected_html =~
             Routes.watch_episode_show_path(conn, :show, another_episode["id"], "continue")
  end
end
