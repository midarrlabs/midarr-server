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

    assert_received {:followed, %{"media_id" => "3", "media_type" => "movie", "user_id" => _user_id}}

    # Not ideal but wait for the message to be processed (async)
    :timer.sleep(1000)

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 1

    assert Enum.at(media, 0).media_id === movie["id"]
    assert Enum.at(media, 0).action_id === MediaServer.Actions.get_followed_id()
  end
end
