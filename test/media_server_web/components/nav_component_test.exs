defmodule MediaServerWeb.Components.NavComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "Movies"
    assert disconnected_html =~ "Series"
    assert disconnected_html =~ "Favourites"
    assert disconnected_html =~ "Continues"
  end

  test "it should search", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    {:ok, _, disconnected_html} =
      view
      |> form("#search", search: %{query: "Some query"})
      |> render_submit()
      |> follow_redirect(conn, Routes.search_index_path(conn, :index, query: "Some query"))

    assert disconnected_html =~ "Some query"
  end
end
