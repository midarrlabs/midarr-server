defmodule MediaServerWeb.UserAccountComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{user: user_fixture()}
  end

  describe "User Account Component" do
    setup [:create_fixtures]

    test "it should update name", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, html} = live(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "Some Name"

      {:ok, _, html} =
        index_live
        |> form("#user-account-form", user: %{name: "Some Updated Name"})
        |> render_submit()
        |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

      refute html =~ "Some Name"
      assert html =~ "Some Updated Name"
    end

    test "it should require name", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, html} = live(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "Some Name"

      assert index_live
             |> form("#user-account-form", user: %{name: ""})
             |> render_submit() =~ "can&#39;t be blank"
    end
  end
end
