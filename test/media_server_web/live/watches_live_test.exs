defmodule MediaServerWeb.WatchesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.WatchStatusesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Index" do
    setup [:create_fixtures]

    test "page", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      conn = get(conn, Routes.watches_index_path(conn, :index))
      assert html_response(conn, 200)
    end

    test "delete", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      movie_watch_status = WatchStatusesFixtures.movie_fixture(%{user_id: user.id})

      {:ok, index_live, _html} = live(conn, Routes.watches_index_path(conn, :index))

      assert index_live |> element("#delete-#{ movie_watch_status.id }") |> render_click()
    end

    test "delete episode", %{conn: conn, user: user} do

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      episode_watch_status = WatchStatusesFixtures.episode_fixture(%{user_id: user.id})

      {:ok, index_live, _html} = live(conn, Routes.watches_index_path(conn, :index))

      assert index_live |> element("#delete-#{ episode_watch_status.id }") |> render_click()
    end
  end
end
