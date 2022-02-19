defmodule MediaServerWeb.UserInvitationComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{user: user_admin_fixture()}
  end

  describe "User Invitation Component" do
    setup [:create_fixtures]

    test "it should show new email address", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#user-form", user: %{email: "test@email.com", name: "Some Name"})
        |> render_submit()
        |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "Some Name"
      assert html =~ "test@email.com"
    end

    test "it should require email address", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      assert index_live
             |> form("#user-form", user: %{email: "", name: "Some Name"})
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "it should require name", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      assert index_live
             |> form("#user-form", user: %{email: "test@email.com", name: ""})
             |> render_submit() =~ "can&#39;t be blank"
    end
  end
end
