defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.Playlists
  alias MediaServerWeb.Repositories.Movies
  alias MediaServer.PlaylistsFixtures

  alias MediaServer.Indexers.Movie

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
    movie = Movie.get_movie("1")
    cast = Movies.get_cast(movie["id"])

    {:ok, view, disconnected_html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:cast, cast})
  end

  test "it should add to playlist", %{conn: conn, user: user} do
    movie = Movie.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])

    PlaylistsFixtures.playlist_fixture(%{user_id: user.id})

    {:ok, view, _disconnected_html} =
      live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert Playlists.list_playlist_movies() |> Enum.empty?()

    send(view.pid, {:cast, cast})

    view
    |> form("#playlist-form", playlist: %{"1" => "true"})
    |> render_change()

    playlist_movie = Playlists.list_playlist_movies() |> List.first()

    assert playlist_movie.movie_id === movie["id"]
  end

  test "it should delete from playlist", %{conn: conn, user: user} do
    movie = Movie.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])
    playlist = PlaylistsFixtures.playlist_fixture(%{user_id: user.id})

    PlaylistsFixtures.movie_fixture(%{movie_id: movie["id"], playlist_id: playlist.id})

    playlist_movie = Playlists.list_playlist_movies() |> List.first()

    assert playlist_movie.movie_id === movie["id"]

    {:ok, view, _disconnected_html} =
      live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:cast, cast})

    view
    |> form("#playlist-form", playlist: %{"1" => "false"})
    |> render_change()

    assert Playlists.list_playlist_movies() |> Enum.empty?()
  end

  test "it should play", %{conn: conn} do
    movie = Movie.get_all() |> List.first()
    cast = Movies.get_cast(movie["id"])

    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:cast, cast})

    assert view |> element("#play-#{movie["id"]}", "Play") |> render_click()
  end
end
