defmodule MediaServerWeb.HistoryLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render", %{conn: conn} do
    {:ok, view, _disconnected_html} = live(conn, ~p"/history")

    assert render(view) =~ "History"
  end
end
