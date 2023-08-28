defmodule MediaServerWeb.UserNavigationTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(MediaServer.AccountsFixtures.user_fixture())}
  end

  test "it should broadcast", %{conn: conn} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "user")

    {:ok, _view, _disconnected_html} = live(conn, ~p"/movies")

    assert_received {:navigated, _}
  end
end
