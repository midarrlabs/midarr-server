defmodule MediaServerWeb.SearchLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should search movies", %{conn: conn} do
    {:ok, view, _disconnected_html} =
      live(conn, Routes.search_index_path(conn, :index, query: "Caminandes"))

    assert render(view) =~ "Caminandes:  Llamigos"
    assert render(view) =~ "Caminandes: Gran Dillama"
    assert render(view) =~ "Caminandes: Llama Drama"

    assert render(view) =~ Routes.movies_show_path(conn, :show, 3)
    assert render(view) =~ Routes.movies_show_path(conn, :show, 2)
    assert render(view) =~ Routes.movies_show_path(conn, :show, 1)
  end

    test "it should normalise movie query", %{conn: conn} do
      {:ok, view, _disconnected_html} =
        live(conn, Routes.search_index_path(conn, :index, query: "camiNandes"))

      assert render(view) =~ "Caminandes:  Llamigos"
      assert render(view) =~ "Caminandes: Gran Dillama"
      assert render(view) =~ "Caminandes: Llama Drama"

      assert render(view) =~ Routes.movies_show_path(conn, :show, 3)
      assert render(view) =~ Routes.movies_show_path(conn, :show, 2)
      assert render(view) =~ Routes.movies_show_path(conn, :show, 1)
    end

  test "it should search series", %{conn: conn} do
    {:ok, view, _disconnected_html} =
      live(conn, Routes.search_index_path(conn, :index, query: "Pioneer"))

    assert render(view) =~ "Pioneer One"
    assert render(view) =~ Routes.series_show_path(conn, :show, 1)
  end

    test "it should normalise series query", %{conn: conn} do
      {:ok, view, _disconnected_html} =
        live(conn, Routes.search_index_path(conn, :index, query: "pioNeer"))

      assert render(view) =~ "Pioneer One"
      assert render(view) =~ Routes.series_show_path(conn, :show, 1)
    end
end
