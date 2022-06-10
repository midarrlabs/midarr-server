defmodule MediaServerWeb.SearchLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures
  alias MediaServer.SeriesFixtures

  defp create_fixtures() do
    %{
      user: AccountsFixtures.user_fixture()
    }
  end

  describe "Index page" do
    setup do
      create_fixtures()
    end

    test "it can search movies", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      {:ok, _index_live, html} = live(conn, Routes.search_index_path(conn, :index, query: "Caminandes Llama Drama"))

      movie = MoviesFixtures.get_movie()

      assert html =~ "Caminandes Llama Drama"
      assert html =~ Routes.movies_show_path(conn, :show, movie["id"])
    end

    test "it can search series", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      {:ok, _index_live, html} = live(conn, Routes.search_index_path(conn, :index, query: "tvdb:170551"))

      serie = SeriesFixtures.get_serie()

      assert html =~ "Pioneer One"
      assert html =~ Routes.series_show_path(conn, :show, serie["id"])
    end
  end
end
