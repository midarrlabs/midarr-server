defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    user = MediaServer.AccountsFixtures.user_fixture()
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: 1)

    %{conn: conn |> log_in_user(user), user: user, movie: movie}
  end

  test "it should render index", %{conn: conn, movie: movie} do
    {:ok, _view, disconnected_html} = live(conn, ~p"/movies")

    assert disconnected_html =~ "/movies/#{movie.id}"
  end

  test "it should render index paged", %{conn: conn, movie: movie} do
    {:ok, _view, disconnected_html} = live(conn, ~p"/movies?page=1")

    assert disconnected_html =~ "/movies/#{movie.id}"
  end

  test "it should render show", %{conn: conn, movie: movie} do
    {:ok, _view, disconnected_html} = live(conn, ~p"/movies/#{movie.id}")

    assert disconnected_html =~ movie.title
  end

  test "it should watch", %{conn: conn, movie: movie} do
    {:ok, view, _html} = live(conn, ~p"/movies/#{movie.id}")

    assert view |> element("#play-#{movie.id}") |> render_click()
  end
end
