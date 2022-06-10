defmodule MediaServerWeb.SearchLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.MoviesFixtures

  defp create_fixtures() do
    %{
      user: AccountsFixtures.user_fixture()
    }
  end

  describe "Index page" do
    setup do
      create_fixtures()
    end

    test "it can search", %{conn: conn, user: user} do
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
  end
end
