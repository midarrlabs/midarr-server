defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
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

  test "it should render show", %{conn: conn} do
    movie = MediaServer.MoviesIndex.find(MediaServer.MoviesIndex.all(), "1")

    {:ok, _view, _disconnected_html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))
  end

  test "it should watch", %{conn: conn} do
    movie = MediaServer.MoviesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, 1))

    assert view |> element("#play-#{movie["id"]}") |> render_click()
  end
end
