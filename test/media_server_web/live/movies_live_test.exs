defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    user = MediaServer.AccountsFixtures.user_fixture()
    movie = MediaServer.Repo.get_by(MediaServer.Movies, id: 1)

    %{conn: conn |> log_in_user(user), user: user, movie: movie}
  end

  test "it should render index", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index))

    assert disconnected_html =~ "Caminandes: Llama Drama"
    assert disconnected_html =~ "Caminandes: Gran Dillama"
    assert disconnected_html =~ "Caminandes: Llamigos"
  end

  test "it should render index paged", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.movies_index_path(conn, :index, page: "1"))

    assert disconnected_html =~ "Caminandes: Llama Drama"
    assert disconnected_html =~ "Caminandes: Gran Dillama"
    assert disconnected_html =~ "Caminandes: Llamigos"
  end

  test "it should render show", %{conn: conn, movie: movie} do
    {:ok, _view, _disconnected_html} = live(conn, ~p"/movies/#{movie.id}")
  end

  test "it should watch", %{conn: conn, movie: movie} do
    {:ok, view, _html} = live(conn, ~p"/movies/#{movie.id}")

    assert view |> element("#play-#{movie.id}") |> render_click()
  end
end
