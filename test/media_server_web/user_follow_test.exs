defmodule MediaServerWeb.UserFollowTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should follow movie", %{conn: conn, user: user} do
    movie = MediaServer.MoviesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, ~p"/movies/#{movie["id"]}")

    view
    |> element("#follow", "Follow")
    |> render_hook(:follow, %{media_id: movie["id"], media_type: "movie", user_id: user.id})

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 1

    assert Enum.at(media, 0).media_id === movie["id"]
    assert Enum.at(media, 0).action_id === MediaServer.Actions.get_followed_id()
  end

  test "it should unfollow movie", %{conn: conn, user: user} do
    movie = MediaServer.MoviesIndex.all() |> List.first()

    MediaServer.MediaActions.create(%{
      media_id: movie["id"],
      user_id: user.id,
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: MediaServer.MediaTypes.get_type_id("movie")
    })

    {:ok, view, _html} = live(conn, ~p"/movies/#{movie["id"]}")

    view
    |> element("#follow", "Following")
    |> render_hook(:unfollow, %{media_id: movie["id"], media_type: "movie", user_id: user.id})

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 0
  end

  test "it should follow series", %{conn: conn, user: user} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, ~p"/series/#{series["id"]}")

    view
    |> element("#follow", "Follow")
    |> render_hook(:follow, %{media_id: series["id"], media_type: "series", user_id: user.id})

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 1

    assert Enum.at(media, 0).media_id === series["id"]
    assert Enum.at(media, 0).action_id === MediaServer.Actions.get_followed_id()
  end

  test "it should unfollow series", %{conn: conn, user: user} do
    series = MediaServer.SeriesIndex.all() |> List.first()

    MediaServer.MediaActions.create(%{
      media_id: series["id"],
      user_id: user.id,
      action_id: MediaServer.Actions.get_followed_id(),
      media_type_id: MediaServer.MediaTypes.get_type_id("series")
    })

    {:ok, view, _html} = live(conn, ~p"/series/#{series["id"]}")

    view
    |> element("#follow", "Following")
    |> render_hook(:unfollow, %{media_id: series["id"], media_type: "series", user_id: user.id})

    media = MediaServer.MediaActions.all()

    assert Enum.count(media) === 0
  end

  test "it should grant push notifications", %{conn: conn, user: user} do
    movie = MediaServer.MoviesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, ~p"/movies/#{movie["id"]}")

    view
    |> element("#follow", "Follow")
    |> render_hook(:grant_push_notifications, %{
      media_id: movie["id"],
      media_type: "movie",
      user_id: user.id,
      push_subscription: "some subscription"
    })

    push_subscriptions = MediaServer.PushSubscriptions.all()

    assert Enum.at(push_subscriptions, 0).push_subscription === "some subscription"
  end

  test "it should deny push notifications", %{conn: conn, user: user} do
    movie = MediaServer.MoviesIndex.all() |> List.first()

    {:ok, view, _html} = live(conn, ~p"/movies/#{movie["id"]}")

    view
    |> element("#follow", "Follow")
    |> render_hook(:deny_push_notifications, %{
      media_id: movie["id"],
      media_type: "movie",
      user_id: user.id,
      message: "some message"
    })

    push_subscriptions = MediaServer.PushSubscriptions.all()

    assert Enum.at(push_subscriptions, 0).push_subscription === "some message"
  end
end
