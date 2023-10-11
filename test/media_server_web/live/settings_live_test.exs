defmodule MediaServerWeb.SettingsLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures

  test "it should not invite users", %{conn: conn} do
    conn = conn |> log_in_user(AccountsFixtures.user_fixture())

    {:ok, _view, disconnected_html} = live(conn, Routes.settings_index_path(conn, :index))

    refute disconnected_html =~ "Invite Users"
  end

  test "it should require account name", %{conn: conn} do
    conn = conn |> log_in_user(AccountsFixtures.user_fixture())

    {:ok, view, disconnected_html} = live(conn, Routes.settings_index_path(conn, :index))

    assert disconnected_html =~ "Some Name"

    assert view
           |> form("#user-account-form", user: %{name: ""})
           |> render_submit() =~ "can&#39;t be blank"
  end

  test "it should update account name", %{conn: conn} do
    conn = conn |> log_in_user(AccountsFixtures.user_fixture())

    {:ok, view, disconnected_html} = live(conn, Routes.settings_index_path(conn, :index))

    assert disconnected_html =~ "Some Name"

    {:ok, _view, disconnected_html} =
      view
      |> form("#user-account-form", user: %{name: "Some Updated Name"})
      |> render_submit()
      |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

    refute disconnected_html =~ "Some Name"
    assert disconnected_html =~ "Some Updated Name"
  end

  test "it should require email address", %{conn: conn} do
    conn = conn |> log_in_user(AccountsFixtures.user_admin_fixture())

    {:ok, view, _disconnected_html} = live(conn, Routes.settings_index_path(conn, :index))

    assert view
           |> form("#user-form", user: %{email: "", name: "Some Name"})
           |> render_submit() =~ "can&#39;t be blank"
  end

  test "it should require name", %{conn: conn} do
    conn = conn |> log_in_user(AccountsFixtures.user_admin_fixture())

    {:ok, view, _disconnected_html} = live(conn, Routes.settings_index_path(conn, :index))

    assert view
           |> form("#user-form", user: %{email: "test@email.com", name: ""})
           |> render_submit() =~ "can&#39;t be blank"
  end

  test "it should show api token", %{conn: conn} do
    user = AccountsFixtures.user_fixture()

    conn = conn |> log_in_user(user)

    {:ok, _view, html} = live(conn, Routes.settings_index_path(conn, :index))

    assert html =~ user.api_token.token
  end
end
