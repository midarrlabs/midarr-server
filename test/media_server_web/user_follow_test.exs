defmodule MediaServerWeb.UserFollowTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should broadcast movie", %{conn: conn} do
    Phoenix.PubSub.subscribe(MediaServer.PubSub, "user")

    movie = MediaServer.MoviesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, ~p"/movies/#{movie["id"]}")

    view |> element("#follow", "Follow") |> render_click()

    assert_received {:followed, "3"}
  end
end
