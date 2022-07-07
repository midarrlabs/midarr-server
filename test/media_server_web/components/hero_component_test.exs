defmodule MediaServerWeb.Components.HeroComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  describe "Hero Component" do
    setup do
      %{
        user: AccountsFixtures.user_fixture()
      }
    end

    test "it should render", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{
            "email" => user.email,
            "password" => AccountsFixtures.valid_user_password()
          }
        })

      {:ok, _index_live, disconnected_html} =
        live(conn, Routes.home_index_path(conn, :index))

      assert disconnected_html =~ "Released"
    end
  end
end
