defmodule MediaServerWeb.WatchLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should segment movie", %{conn: conn} do
    movie = MediaServer.MoviesIndex.get_movie("1")

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, movie: movie["id"], type: "segment"))

    assert disconnected_html =~ "media-player"
    assert disconnected_html =~ "media-outlet"
  end

  test "it should segment episode", %{conn: conn} do
    episode = MediaServerWeb.Repositories.Episodes.get_episode(1)

    {:ok, _view, disconnected_html} =
      live(conn, Routes.watch_index_path(conn, :index, episode: episode["id"], type: "segment"))

    assert disconnected_html =~ "media-player"
    assert disconnected_html =~ "media-outlet"
  end
end
