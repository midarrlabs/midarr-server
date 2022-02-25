defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures

  test "GET /movies", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    conn = get(conn, "/movies")
    assert html_response(conn, 200)
  end

  test "GET /movies show", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    movie = MoviesFixtures.get_movie()

    conn = get(conn, Routes.movies_show_path(conn, :show, movie["id"]))
    assert html_response(conn, 200)
  end

  test "Get /movies play", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    movie = MoviesFixtures.get_movie()

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie["id"]))

    assert show_live |> element("button", "Play") |> render_click()
  end
end
