defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServerWeb.Repositories.Movies

  alias MediaServer.Movies.Indexer

  setup %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    %{conn: conn |> log_in_user(user), user: user}
  end

  test "it should render index", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index))

    assert disconnected_html =~ "Caminandes: Llama Drama"
    assert disconnected_html =~ "Caminandes: Gran Dillama"
    assert disconnected_html =~ "Caminandes:  Llamigos"
  end

  test "it should render index paged", %{conn: conn} do
    {:ok, _view, disconnected_html} =
      live(conn, Routes.movies_index_path(conn, :index, page: "1"))

    assert disconnected_html =~ "Caminandes: Llama Drama"
    assert disconnected_html =~ "Caminandes: Gran Dillama"
    assert disconnected_html =~ "Caminandes:  Llamigos"
  end

  test "it should render show", %{conn: conn} do
    movie = Indexer.get_movie("1")
    cast = Movies.get_cast(movie["id"])

    {:ok, view, disconnected_html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:cast, cast})
  end

  test "it should add to playlist", %{conn: conn, user: user} do
    movie = Indexer.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])

    MediaServer.Playlists.Playlist.create(%{name: "some playlist", user_id: user.id})

    {:ok, view, _disconnected_html} =
      live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:cast, cast})

    view
    |> form("#playlist-form", playlist: %{"1" => "true"})
    |> render_change()

    playlist_movie = MediaServer.Movies.Playlist.all() |> List.first()
    media = MediaServer.Media.all() |> List.first()

    assert playlist_movie.media_id === media.id
  end

  test "it should delete from playlist", %{conn: conn, user: user} do
    movie = Indexer.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])
    MediaServer.Playlists.Playlist.create(%{name: "some playlist", user_id: user.id})
    MediaServer.Playlists.Playlist.create(%{name: "another playlist", user_id: user.id})

    {:ok, view, _disconnected_html} =
      live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:cast, cast})

    view
    |> form("#playlist-form", playlist: %{"1" => "true", "2" => "true"})
    |> render_change()

    assert Enum.count(MediaServer.Movies.Playlist.all()) === 2

    view
    |> form("#playlist-form", playlist: %{"1" => "false", "2" => "true"})
    |> render_change()

    assert Enum.count(MediaServer.Movies.Playlist.all()) === 1
  end

  test "it should play", %{conn: conn} do
    movie = Indexer.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])

    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:cast, cast})

    assert view |> element("#play-#{movie["id"]}", "Play") |> render_click()
  end
end
