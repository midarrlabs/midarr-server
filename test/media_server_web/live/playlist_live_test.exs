defmodule MediaServerWeb.PlaylistLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.PlaylistsFixtures

  alias MediaServer.AccountsFixtures

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()
    playlist = playlist_fixture(%{user_id: user.id})

    %{conn: conn |> log_in_user(user), user: user, playlist: playlist}
  end

  test "it should list only logged in user playlists", %{conn: conn, playlist: playlist} do
    anotherUser = AccountsFixtures.user_fixture()
    anotherPlaylist = playlist_fixture(%{user_id: anotherUser.id, name: "another playlist"})

    {:ok, _index_live, html} = live(conn, Routes.playlist_index_path(conn, :index))

    assert html =~ "Playlists"
    assert html =~ playlist.name

    refute html =~ anotherPlaylist.name
  end

  test "saves new playlist", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, Routes.playlist_index_path(conn, :index))

    {:ok, _, html} =
      index_live
      |> form("#playlist-form", playlist: %{name: "some name"})
      |> render_submit()
      |> follow_redirect(conn, Routes.playlist_index_path(conn, :index))

    assert html =~ "some name"
  end

  test "it should only display logged in user playlist", %{conn: conn, playlist: playlist} do
    {:ok, _show_live, html} = live(conn, Routes.playlist_show_path(conn, :show, playlist))

    assert html =~ playlist.name

    anotherUser = AccountsFixtures.user_fixture()
    anotherPlaylist = playlist_fixture(%{user_id: anotherUser.id, name: "another playlist"})

    assert_raise Ecto.NoResultsError, fn ->
      live(conn, Routes.playlist_show_path(conn, :show, anotherPlaylist))
    end
  end
end
