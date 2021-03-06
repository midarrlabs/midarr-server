defmodule MediaServerWeb.WatchEpisodeLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServer.EpisodesFixtures
  alias MediaServer.ContinuesFixtures
  alias MediaServer.ComponentsFixtures
  alias MediaServer.Actions

  defp create_fixtures(_) do
    ComponentsFixtures.action_fixture()
    %{user: AccountsFixtures.user_fixture()}
  end

  describe "Show page" do
    setup [:create_fixtures]

    test "it can watch", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, view, _html} = live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      render_hook(view, :video_played)

      assert Enum.count(Actions.list_episode_actions()) === 1
    end

    test "it has continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, view, _html} = live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      render_hook(view, :video_destroyed, %{
        episode_id: episode["id"],
        serie_id: episode["seriesId"],
        current_time: 39,
        duration: 78,
        user_id: user.id
      })

      assert ContinuesFixtures.get_episode_continue()
    end

    test "it does not have continue", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, view, _html} = live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      render_hook(view, :video_destroyed, %{
        episode_id: episode["id"],
        serie_id: episode["seriesId"],
        current_time: 90,
        duration: 100,
        user_id: user.id
      })

      refute ContinuesFixtures.get_episode_continue()
    end

    test "it has subtitle", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      serie = SeriesFixtures.get_serie()

      episode = EpisodesFixtures.get_episode(serie["id"])

      {:ok, _view, disconnected_html} =
        live(conn, Routes.watch_episode_show_path(conn, :show, episode["id"]))

      assert disconnected_html =~ Routes.subtitle_episode_path(conn, :show, episode["id"])
    end

    test "it does not have subtitle", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          "user" => %{"email" => user.email, "password" => AccountsFixtures.valid_user_password()}
        })

      {:ok, _view, disconnected_html} = live(conn, Routes.watch_episode_show_path(conn, :show, 3))

      refute disconnected_html =~ Routes.subtitle_episode_path(conn, :show, 3)
    end
  end
end
