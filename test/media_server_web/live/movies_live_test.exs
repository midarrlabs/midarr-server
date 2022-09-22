defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.Playlists
  alias MediaServer.Playlists.Movie
  alias MediaServerWeb.Repositories.Movies

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render index", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index))

    assert disconnected_html =~ "loading-spinner"

    movies = Movies.get_all()

    send(view.pid, {:movies, movies})
  end

  test "it should render index paged", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index, page: "1"))

    assert disconnected_html =~ "loading-spinner"

    movies = Movies.get_all()

    send(view.pid, {:movies, movies})
  end

  test "it should render show", %{conn: conn} do
    movie = MoviesFixtures.get_movie()
    cast = Movies.get_cast(movie["id"])

    {:ok, view, disconnected_html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:movie, movie})
    send(view.pid, {:cast, cast})
  end

  test "it should add to playlist", %{conn: conn} do
    movie = MoviesFixtures.get_movie()
    cast = Movies.get_cast(movie["id"])

    {:ok, view, _disconnected_html} =
      live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert Movie.list_playlist_movies() |> Enum.empty?()

    send(view.pid, {:movie, movie})
    send(view.pid, {:cast, cast})

    playlist_movie = Movie.list_playlist_movies() |> List.first()

    assert playlist_movie.movie_id === movie["id"]
  end

  #  test "it should delete from playlist", %{conn: conn} do
  #    movie = MoviesFixtures.get_movie()
  #    cast = Movies.get_cast(movie["id"])
  #
  #    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))
  #
  #    send(view.pid, {:movie, movie})
  #    send(view.pid, {:cast, cast})
  #
  #    assert view
  #           |> element("#favourite", "Favourite")
  #           |> render_click()
  #
  #    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))
  #
  #    send(view.pid, {:movie, movie})
  #    send(view.pid, {:cast, cast})
  #
  #    assert view
  #           |> element("#unfavourite", "Unfavourite")
  #           |> render_click()
  #
  #    assert Favourites.list_movie_favourites()
  #           |> Enum.empty?()
  #  end

  test "it should play", %{conn: conn} do
    movie = MoviesFixtures.get_movie()
    cast = Movies.get_cast(movie["id"])

    {:ok, view, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    send(view.pid, {:movie, movie})
    send(view.pid, {:cast, cast})

    assert view |> element("#play-#{movie["id"]}", "Play") |> render_click()
  end
end
