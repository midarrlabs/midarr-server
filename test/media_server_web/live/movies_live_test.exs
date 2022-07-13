defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.Favourites
  alias MediaServerWeb.Repositories.Movies

  test "index movies", %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    {:ok, view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index))

    assert disconnected_html =~ "loading-spinner"

    movies = Movies.get_all()

    send(view.pid, {:movies, movies})
  end

  test "index paged movies", %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    {:ok, view, disconnected_html} = live(conn, Routes.movies_index_path(conn, :index, page: "1"))

    assert disconnected_html =~ "loading-spinner"

    movies = Movies.get_all()

    send(view.pid, {:movies, movies})
  end

  test "it can render show page", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    movie = MoviesFixtures.get_movie()

    conn = get(conn, Routes.movies_show_path(conn, :show, movie["id"]))
    assert html_response(conn, 200)
  end

  test "it can favourite", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    movie = MoviesFixtures.get_movie()

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert Favourites.list_movie_favourites()
           |> Enum.empty?()

    assert show_live |> element("#favourite", "Favourite") |> render_click()

    favourite =
      Favourites.list_movie_favourites()
      |> List.first()

    assert favourite.movie_id === movie["id"]
  end

  test "it can unfavourite", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    movie = MoviesFixtures.get_movie()

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert show_live
           |> element("#favourite", "Favourite")
           |> render_click()

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert show_live
           |> element("#unfavourite", "Unfavourite")
           |> render_click()

    assert Favourites.list_movie_favourites()
           |> Enum.empty?()
  end

  test "it can click play button on show page", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    movie = MoviesFixtures.get_movie()

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert show_live |> element("#play-#{movie["id"]}", "Play") |> render_click()
  end
end
