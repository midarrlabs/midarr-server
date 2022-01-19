defmodule MediaServerWeb.SonarrLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.IntegrationsFixtures
  import MediaServer.AccountsFixtures

  @create_attrs %{api_key: "some api_key", name: "some name", url: "some url"}
  @update_attrs %{api_key: "some updated api_key", name: "some updated name", url: "some updated url"}
  @invalid_attrs %{api_key: nil, name: nil, url: nil}

  defp create_sonarr(_) do
    sonarr = sonarr_fixture()
    %{sonarr: sonarr, user: user_fixture()}
  end

  describe "Index" do
    setup [:create_sonarr]

    test "lists all sonarrs", %{conn: conn, sonarr: sonarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, _index_live, html} = live(conn, Routes.sonarr_index_path(conn, :index))

      assert html =~ "Listing Sonarrs"
      assert html =~ sonarr.api_key
    end

    test "saves new sonarr", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.sonarr_index_path(conn, :index))

      assert index_live |> element("a", "New Sonarr") |> render_click() =~
               "New Sonarr"

      assert_patch(index_live, Routes.sonarr_index_path(conn, :new))

      assert index_live
             |> form("#sonarr-form", sonarr: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sonarr-form", sonarr: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sonarr_index_path(conn, :index))

      assert html =~ "Listing Sonarrs"
      assert html =~ "some api_key"
    end

    test "updates sonarr in listing", %{conn: conn, sonarr: sonarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.sonarr_index_path(conn, :index))

      assert index_live |> element("#sonarr-#{sonarr.id} a", "Edit") |> render_click() =~
               "Edit Sonarr"

      assert_patch(index_live, Routes.sonarr_index_path(conn, :edit, sonarr))

      assert index_live
             |> form("#sonarr-form", sonarr: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sonarr-form", sonarr: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sonarr_index_path(conn, :index))

      assert html =~ "Listing Sonarrs"
      assert html =~ "some updated api_key"
    end

    test "deletes sonarr in listing", %{conn: conn, sonarr: sonarr, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => valid_user_password()}
        })

      {:ok, index_live, _html} = live(conn, Routes.sonarr_index_path(conn, :index))

      assert index_live |> element("#sonarr-#{sonarr.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sonarr-#{sonarr.id}")
    end
  end
end
