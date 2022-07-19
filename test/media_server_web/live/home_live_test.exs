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

    assert html_response(get(conn, "/"), 200)

    MoviesFixtures.add_env()
  end

  test "it should render without series", %{conn: conn} do
    SeriesFixtures.remove_env()

    assert html_response(get(conn, "/"), 200)

    SeriesFixtures.add_env()
  end

  test "latest movies section", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "loading-movies"

    movies = Movies.get_latest(7)

    send(view.pid, {:movies, movies})

    assert render(view) =~ "Caminandes: Llama Drama"
    assert render(view) =~ "Caminandes: Gran Dillama"
    refute render(view) =~ "Caminandes: Llamigos"
  end

  test "latest series section", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "loading-series"

    series = Series.get_latest(6)

    send(view.pid, {:series, series})

    assert render(view) =~ "Pioneer One"
  end
end
