defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServerWeb.Repositories.Movies
  alias MediaServerWeb.Repositories.Series

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render without movies", %{conn: conn} do
    MoviesFixtures.remove_env()

    {:ok, _view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "Movies"
    assert disconnected_html =~ "Series"
    assert disconnected_html =~ "Favourites"
    assert disconnected_html =~ "Continues"

    MoviesFixtures.add_env()
  end

  test "it should render without series", %{conn: conn} do
    SeriesFixtures.remove_env()

    {:ok, _view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "Movies"
    assert disconnected_html =~ "Series"
    assert disconnected_html =~ "Favourites"
    assert disconnected_html =~ "Continues"

    SeriesFixtures.add_env()
  end

  test "it has latest movies", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "loading-movies"

    movies = Movies.get_latest(7)

    send(view.pid, {:movies, movies})

    assert render(view) =~ "Caminandes: Llama Drama"
    assert render(view) =~ "Caminandes: Gran Dillama"
    refute render(view) =~ "Caminandes: Llamigos"
  end

  test "it has latest series", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "loading-series"

    series = Series.get_latest(6)

    send(view.pid, {:series, series})

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
end
