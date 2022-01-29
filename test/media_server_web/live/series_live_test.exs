defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest
  import MediaServer.AccountsFixtures
  import MediaServer.IntegrationsFixtures

  alias MediaServerWeb.Repositories.Series

  test "GET /series", %{conn: conn} do
    fixture = %{
      user: user_fixture(),
      sonarr: real_sonarr_fixture()
    }

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/series")
    assert html_response(conn, 200)
  end

  test "GET /series show", %{conn: conn} do
    fixture = %{
      user: user_fixture()
    }

    {_sonarr, series_id, _episode_id} = real_sonarr_fixture()

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => valid_user_password()}
      })

    conn = get(conn, "/series/#{ series_id }")
    assert html_response(conn, 200)

    {:ok, show_live, _html} = live(conn, Routes.series_show_path(conn, :show, series_id))

    assert show_live |> element("button", "Play") |> render_click()
  end

  test "it should merge episode images with serie episode", %{conn: _conn} do
    {_sonarr, series_id, _episode_id} = real_sonarr_fixture()

    episodes = Series.get_episodes(series_id)

    assert Series.add_images_to_episodes(episodes) === [
             %{
               "absoluteEpisodeNumber" => 1,
               "airDate" => "1962-09-26",
               "airDateUtc" => "1962-09-26T23:30:00Z",
               "episodeFileId" => 8,
               "episodeNumber" => 1,
               "hasFile" => true,
               "id" => 2007,
               "images" => [
                 %{
                   "coverType" => "screenshot",
                   "url" => "https://artworks.thetvdb.com/banners/episodes/71471/46686.jpg"
                 }
               ],
               "monitored" => false,
               "overview" => "When an oil wildcatter discovers a huge pool of oil in Jed Clampetts’ swamp, Jed sells his land to the O.K. Oil Company for $34 million. At the urging of his cousin, Pearl, Jed moves his family to a 35 room mansion in Beverly Hills, California.",
               "seasonNumber" => 1,
               "seriesId" => 8,
               "title" => "The Clampetts Strike Oil",
               "unverifiedSceneNumbering" => false
             }
           ]
  end
end
