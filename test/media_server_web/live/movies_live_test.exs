defmodule MediaServerWeb.MoviesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

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
      user: user_fixture()
    }

    {_radarr, movie_id} = real_radarr_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/movies/#{ movie_id }")
    assert html_response(conn, 200)
  end

  test "Get /movies play", %{conn: conn} do

    fixture = %{
      user: user_fixture()
    }

    {_radarr, movie_id} = real_radarr_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    {:ok, show_live, _html} = live(conn, Routes.movies_show_path(conn, :show, movie_id))

    assert show_live |> element("button", "Play") |> render_click()
  end
end
