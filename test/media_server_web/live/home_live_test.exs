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
    assert disconnected_html =~ "Caminandes: Llamigos"
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

    assert disconnected_html =~ "Search"
  end
end
