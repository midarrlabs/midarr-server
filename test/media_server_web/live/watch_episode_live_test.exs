defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServer.EpisodesFixtures
  alias MediaServer.ContinuesFixtures

  defp create_fixtures(_) do
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Show episode" do
    setup [:create_fixtures]

    test "continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      conn = get(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))
      assert html_response(conn, 200)
    end

    test "has continue status", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, view, _html} = live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      render_hook(view, :episode_destroyed, %{
        episode_id: episode["id"],
        serie_id: episode["seriesId"],
        current_time: 39,
        duration: 78,
        user_id: user.id
      })

      assert ContinuesFixtures.get_episode_continue()
    end

    test "no continue status", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, view, _html} = live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      render_hook(view, :episode_destroyed, %{
        episode_id: episode["id"],
        serie_id: episode["seriesId"],
        current_time: 90,
        duration: 100,
        user_id: user.id
      })

      refute ContinuesFixtures.get_episode_continue()
    end
  end
end
