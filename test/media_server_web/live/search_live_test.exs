defmodule MediaServerWeb.SearchLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServerWeb.Repositories.Series

  alias MediaServer.Movies.Indexer

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should search movies", %{conn: conn} do
    {:ok, view, _disconnected_html} =
      live(conn, Routes.search_index_path(conn, :index, query: "Caminandes Llama Drama"))

    movie = Indexer.get_movie("1")

    send(view.pid, {:movies, [movie]})
    send(view.pid, {:series, []})

    assert render(view) =~ "Caminandes: Llama Drama"
    assert render(view) =~ Routes.movies_show_path(conn, :show, movie["id"])
  end

  test "it should search series", %{conn: conn} do
    {:ok, view, _disconnected_html} =
      live(conn, Routes.search_index_path(conn, :index, query: "tvdb:170551"))

    serie = Series.get_all() |> List.first()

    send(view.pid, {:series, [serie]})
    send(view.pid, {:movies, []})

    assert render(view) =~ "Pioneer One"
    assert render(view) =~ Routes.series_show_path(conn, :show, serie["id"])
  end
end
