defmodule MediaServerWeb.SettingsLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Index" do
    setup [:create_fixtures]

    test "it shows sections", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, _index_live, html} = live(conn, Routes.settings_index_path(conn, :index))

      refute html =~ "Invite Users"
    end
  end
end
