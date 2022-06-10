defmodule MediaServerWeb.Components.NavComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  defp create_fixtures() do
    %{
      user: AccountsFixtures.user_fixture()
    }
  end

  describe "Component" do
    setup do
      create_fixtures()
    end

    test "it should render", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      {:ok, _index_live, html} = live(conn, Routes.components_index_path(conn, :index))

      assert html =~ "Movies"
      assert html =~ "Series"
      assert html =~ "Favourites"
      assert html =~ "Continues"
    end

    test "it can query search", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      {:ok, index_live, _html} = live(conn, Routes.components_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#search", search: %{query: "Some query"})
        |> render_submit()
        |> follow_redirect(conn, Routes.search_index_path(conn, :index, query: "Some query"))

      assert html =~ "Some query"
    end
  end
end
