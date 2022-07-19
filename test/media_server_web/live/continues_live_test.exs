defmodule MediaServerWeb.ContinuesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.ContinuesFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should render", %{conn: conn, user: _user} do
    assert html_response(get(conn, Routes.continues_index_path(conn, :index)), 200)
  end

  test "it can delete movie continue", %{conn: conn, user: user} do
    movie_continue_status = ContinuesFixtures.movie_fixture(%{user_id: user.id})

    {:ok, index_live, _html} = live(conn, Routes.continues_index_path(conn, :index))

    assert index_live |> element("#movie-#{movie_continue_status.id}") |> render_click()
  end

  test "it can delete episode continue", %{conn: conn, user: user} do
    episode_continue_status = ContinuesFixtures.episode_fixture(%{user_id: user.id})

    {:ok, index_live, _html} = live(conn, Routes.continues_index_path(conn, :index))

    assert index_live |> element("#episode-#{episode_continue_status.id}") |> render_click()
  end
end
