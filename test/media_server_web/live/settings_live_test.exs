defmodule MediaServerWeb.SettingsLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures

  @create_attrs %{api_key: "some api_key", name: "some name", url: "some url"}

  defp create_fixtures(_) do
    %{user: user_fixture()}
  end

  describe "Index" do
    setup [:create_fixtures]

    test "it shows sections", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, _index_live, html} = live(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "User Invite"
      assert html =~ "Radarr Integration"
      assert html =~ "Sonarr Integration"
    end

    test "it creates radarr", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#radarr-form", radarr: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "some api_key"
      assert html =~ "some name"
      assert html =~ "some url"
    end

    test "it creates sonarr", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.settings_index_path(conn, :index))

      {:ok, _, html} =
        index_live
        |> form("#sonarr-form", sonarr: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.settings_index_path(conn, :index))

      assert html =~ "some api_key"
      assert html =~ "some name"
      assert html =~ "some url"
    end
  end
end
