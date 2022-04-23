defmodule MediaServerWeb.SettingsLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  defp create_fixtures(_) do
    %{
      user: AccountsFixtures.user_fixture(),
      admin: AccountsFixtures.user_admin_fixture()
    }
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

    test "it should update account name", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
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

    test "it should require account name", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, index_live, html} = live(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "Some Name"

      assert index_live
             |> form("#user-account-form", user: %{name: ""})
             |> render_submit() =~ "can&#39;t be blank"
    end
  end

  describe "Invite users" do
    setup [:create_fixtures]

    test "it should show new email address", %{conn: conn, admin: admin} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => admin.email, "password" => AccountsFixtures.valid_user_password()}
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

    test "it should require email address", %{conn: conn, admin: admin} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => admin.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      assert index_live
             |> form("#user-form", user: %{email: "", name: "Some Name"})
             |> render_submit() =~ "can&#39;t be blank"
    end

    test "it should require name", %{conn: conn, admin: admin} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => admin.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      assert index_live
             |> form("#user-form", user: %{email: "test@email.com", name: ""})
             |> render_submit() =~ "can&#39;t be blank"
    end
  end
end
