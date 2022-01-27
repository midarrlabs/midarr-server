defmodule MediaServerWeb.UserInvitationComponentTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{user: user_fixture()}
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
        |> form("#user-invite-form", email: "test@email.com", name: "Some Name")
        |> render_submit()
        |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "Some Name"
      assert html =~ "test@email.com"
    end
  end
end
