defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures
  import MediaServer.ProvidersFixtures

  test "GET /movies", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      radarr: real_radarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/movies")
    assert html_response(conn, 200)
  end

  test "GET /movies show", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      radarr: real_radarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/movies/1")
    assert html_response(conn, 200)
  end

  test "Get /movies play", %{conn: conn} do

    fixture = %{
      user: user_fixture(),
      radarr: real_radarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, 1))

    assert show_live |> element("button", "Play") |> render_click()
  end
end
