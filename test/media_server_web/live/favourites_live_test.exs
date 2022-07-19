defmodule MediaServerWeb.FavouritesLiveTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render", %{conn: conn} do
    assert html_response(get(conn, Routes.favourites_index_path(conn, :index)), 200)
  end
end
