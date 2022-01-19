defmodule MediaServerWeb.RadarrLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.IntegrationsFixtures
  import MediaServer.AccountsFixtures

  @create_attrs %{api_key: "some api_key", name: "some name", url: "some url"}
  @update_attrs %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}
  @invalid_attrs %{api_key: nil, name: nil, url: nil}

  defp create_radarr(_) do
    radarr = radarr_fixture()
    %{radarr: radarr, user: user_fixture()}
  end

  describe "Index" do
    setup [:create_radarr]

    test "lists all radarrs", %{conn: conn, radarr: radarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, _index_live, html} = live(conn, Routes.radarr_index_path(conn, :index))

      assert html =~ "Listing Radarrs"
      assert html =~ radarr.api_key
    end

    test "saves new radarr", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.radarr_index_path(conn, :index))

      assert index_live |> element("a", "New Radarr") |> render_click() =~
               "New Radarr"

      assert_patch(index_live, Routes.radarr_index_path(conn, :new))

      assert index_live
             |> form("#radarr-form", radarr: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#radarr-form", radarr: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.radarr_index_path(conn, :index))

      assert html =~ "Listing Radarrs"
      assert html =~ "some api_key"
    end

    test "updates radarr in listing", %{conn: conn, radarr: radarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.radarr_index_path(conn, :index))

      assert index_live |> element("#radarr-#{radarr.id} a", "Edit") |> render_click() =~
               "Edit Radarr"

      assert_patch(index_live, Routes.radarr_index_path(conn, :edit, radarr))

      assert index_live
             |> form("#radarr-form", radarr: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#radarr-form", radarr: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.radarr_index_path(conn, :index))

      assert html =~ "Listing Radarrs"
      assert html =~ "some updated api_key"
    end

    test "deletes radarr in listing", %{conn: conn, radarr: radarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.radarr_index_path(conn, :index))

      assert index_live |> element("#radarr-#{radarr.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#radarr-#{radarr.id}")
    end
  end
end
