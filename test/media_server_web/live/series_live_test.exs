defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServer.EpisodesFixtures
  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Favourites

  test "GET /series", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    conn = get(conn, "/series")
    assert html_response(conn, 200)
  end

  test "GET /series show", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    serie = SeriesFixtures.get_serie()

    conn = get(conn, "/series/#{serie["id"]}")
    assert html_response(conn, 200)

    EpisodesFixtures.get_episodes(serie["id"])
    |> Enum.each(fn episode ->
      {:ok, show_live, _html} =
        live(conn, Routes.seasons_show_path(conn, :show, serie["id"], episode["seasonNumber"]))

      assert show_live |> element("#play-#{episode["id"]}", "Play") |> render_click()
    end)
  end

  test "it can favourite", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    serie = SeriesFixtures.get_serie()

    {:ok, show_live, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert Favourites.list_serie_favourites()
           |> Enum.empty?()

    assert show_live |> element("#favourite", "Favourite") |> render_click()

    favourite =
      Favourites.list_serie_favourites()
      |> List.first()

    assert favourite.serie_id === serie["id"]
  end

  test "it can unfavourite", %{conn: conn} do
    fixture = %{user: AccountsFixtures.user_fixture()}

    conn =
      post(conn, Routes.user_session_path(conn, :create), %{
        "user" => %{
          "email" => fixture.user.email,
          "password" => AccountsFixtures.valid_user_password()
        }
      })

    serie = SeriesFixtures.get_serie()

    {:ok, show_live, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert show_live
           |> element("#favourite", "Favourite")
           |> render_click()

    {:ok, show_live, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert show_live
           |> element("#unfavourite", "Unfavourite")
           |> render_click()

    assert Favourites.list_serie_favourites()
           |> Enum.empty?()
  end

  test "it should merge episode images with serie episode", %{conn: _conn} do
    serie = SeriesFixtures.get_serie()

    episodes = Episodes.get_all(serie["id"], "1")

    assert episodes === [
             %{
               "airDate" => "2010-06-16",
               "airDateUtc" => "2010-06-16T04:00:00Z",
               "episodeFileId" => 1,
               "episodeNumber" => 1,
               "hasFile" => true,
               "id" => 1,
               "images" => [
                 %{
                   "coverType" => "screenshot",
                   "url" => "https://artworks.thetvdb.com/banners/episodes/170551/2375761.jpg"
                 }
               ],
               "monitored" => false,
               "overview" =>
                 "An object from space spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover is a forgotten relic of the old Soviet space program, whose return to Earth will have implications for the entire world.",
               "seasonNumber" => 1,
               "seriesId" => 1,
               "title" => "Earthfall",
               "unverifiedSceneNumbering" => false
             },
             %{
               "airDate" => "2010-06-25",
               "airDateUtc" => "2010-06-25T04:00:00Z",
               "episodeFileId" => 2,
               "episodeNumber" => 2,
               "hasFile" => true,
               "id" => 2,
               "images" => [
                 %{
                   "coverType" => "screenshot",
                   "url" => "https://artworks.thetvdb.com/banners/episodes/170551/3294321.jpg"
                 }
               ],
               "monitored" => false,
               "overview" =>
                 "Hired Mars expert Dr. Zachary Walzer (Jack Haley) fights to prove the validity of the Mars story. Can he convince the government to mount a manned mission to Mars? Agent in charge Tom Taylor (James Rich) faces pressure from both the Canadians and his own superiors, and has to make a call.",
               "seasonNumber" => 1,
               "seriesId" => 1,
               "title" => "The Man From Mars",
               "unverifiedSceneNumbering" => false
             }
           ]
  end
end
