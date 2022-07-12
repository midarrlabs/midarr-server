defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServerWeb.Repositories.Movies

  describe "without integrations" do
    setup do
      MoviesFixtures.remove_env()
      SeriesFixtures.remove_env()

      on_exit(fn ->
        MoviesFixtures.add_env()
        SeriesFixtures.add_env()
      end)
    end

    test "without movies", %{conn: conn} do
      fixture = %{user: AccountsFixtures.user_fixture()}

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => fixture.user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      conn = get(conn, "/")
      assert html_response(conn, 200)
    end

    test "without series", %{conn: conn} do
      fixture = %{user: AccountsFixtures.user_fixture()}

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => fixture.user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      conn = get(conn, "/")
      assert html_response(conn, 200)
    end
  end

  test "with integrations", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end

  test "latest movies section", %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    {:ok, view, disconnected_html} = live(conn, Routes.home_index_path(conn, :index))

    assert disconnected_html =~ "loading-movies"

    movies = Movies.get_latest(7)

    send(view.pid, {:movies, movies})

    assert render(view) =~ "Caminandes: Llama Drama"
    assert render(view) =~ "Caminandes: Gran Dillama"
    refute render(view) =~ "Caminandes: Llamigos"
  end
end
