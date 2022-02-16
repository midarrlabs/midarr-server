defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServerWeb.Repositories.Series

  test "GET /series", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    conn = get(conn, "/series")
    assert html_response(conn, 200)
  end

  test "GET /series show", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{"email" => fixture.user.email, "password" => AccountsFixtures.valid_user_password()}
      })

    serie = SeriesFixtures.get_serie()

    conn = get(conn, "/series/#{ serie["id"] }")
    assert html_response(conn, 200)

    {:ok, show_live, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert show_live |> element("button", "Play") |> render_click()
  end

  test "it should merge episode images with serie episode", %{conn: _conn} do
    serie = SeriesFixtures.get_serie()

    episodes = Series.get_episodes(serie["id"])

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
