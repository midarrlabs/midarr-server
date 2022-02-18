defmodule MediaServerWeb.HomeLiveTest do
  use MediaServerWeb.ConnCase

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.SeriesFixtures

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
          "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      conn = get(conn, "/")
      assert html_response(conn, 200)
    end

    test "without series", %{conn: conn} do
      fixture = %{user: AccountsFixtures.user_fixture()}

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      conn = get(conn, "/")
      assert html_response(conn, 200)
    end
  end

  test "with integrations", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
