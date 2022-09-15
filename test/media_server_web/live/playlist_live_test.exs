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

    assert html =~ "Listing Playlists"
    assert html =~ playlist.name

    refute html =~ anotherPlaylist.name
  end

  test "saves new playlist", %{conn: conn} do
    {:ok, index_live, _html} = live(conn, Routes.playlist_index_path(conn, :index))

    assert index_live |> element("a", "New Playlist") |> render_click() =~
             "New Playlist"

    assert_patch(index_live, Routes.playlist_index_path(conn, :new))

    assert index_live
           |> form("#playlist-form", playlist: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"

    {:ok, _, html} =
      index_live
      |> form("#playlist-form", playlist: %{name: "some name"})
      |> render_submit()
      |> follow_redirect(conn, Routes.playlist_index_path(conn, :index))

    assert html =~ "some name"
  end

  test "updates playlist in listing", %{conn: conn, playlist: playlist} do
    {:ok, index_live, _html} = live(conn, Routes.playlist_index_path(conn, :index))

    assert index_live |> element("#playlist-#{playlist.id} a", "Edit") |> render_click() =~
             "Edit Playlist"

    assert_patch(index_live, Routes.playlist_index_path(conn, :edit, playlist))

    assert index_live
           |> form("#playlist-form", playlist: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"

    {:ok, _, html} =
      index_live
      |> form("#playlist-form", playlist: %{name: "some updated name name"})
      |> render_submit()
      |> follow_redirect(conn, Routes.playlist_index_path(conn, :index))

    assert html =~ "some updated name"
  end

  test "deletes playlist in listing", %{conn: conn, playlist: playlist} do
    {:ok, index_live, _html} = live(conn, Routes.playlist_index_path(conn, :index))

    assert index_live |> element("#playlist-#{playlist.id} a", "Delete") |> render_click()
  end

  test "it should only display logged in user playlist", %{conn: conn, playlist: playlist} do
    {:ok, _show_live, html} = live(conn, Routes.playlist_show_path(conn, :show, playlist))

    assert html =~ "Show Playlist"
    assert html =~ playlist.name

    anotherUser = AccountsFixtures.user_fixture()
    anotherPlaylist = playlist_fixture(%{user_id: anotherUser.id, name: "another playlist"})

    {:error, {result, _}} = live(conn, Routes.playlist_show_path(conn, :show, anotherPlaylist))

    assert result === :live_redirect
  end

  test "updates playlist within modal", %{conn: conn, playlist: playlist} do
    {:ok, show_live, _html} = live(conn, Routes.playlist_show_path(conn, :show, playlist))

    assert show_live |> element("a", "Edit") |> render_click() =~
             "Edit Playlist"

    assert_patch(show_live, Routes.playlist_show_path(conn, :edit, playlist))

    assert show_live
           |> form("#playlist-form", playlist: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"

    {:ok, _, html} =
      show_live
      |> form("#playlist-form", playlist: %{name: "some updated name name"})
      |> render_submit()
      |> follow_redirect(conn, Routes.playlist_show_path(conn, :show, playlist))

    assert html =~ "some updated name"
  end
end
