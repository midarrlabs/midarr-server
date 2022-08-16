defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServer.SeriesFixtures
  alias MediaServerWeb.Repositories.Episodes
  alias MediaServer.Favourites
  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render index", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.series_index_path(conn, :index))

    assert disconnected_html =~ "loading-spinner"

    series = Series.get_all()

    send(view.pid, {:series, series})
  end

  test "it should render index paged", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, Routes.series_index_path(conn, :index, page: "1"))

    assert disconnected_html =~ "loading-spinner"

    series = Series.get_all()

    send(view.pid, {:series, series})
  end

  test "it should render show", %{conn: conn} do
    serie = SeriesFixtures.get_serie()

    {:ok, view, disconnected_html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:serie, serie})
  end

  test "it should render season", %{conn: conn} do
    serie = SeriesFixtures.get_serie()

    {:ok, view, disconnected_html} =
      live(conn, Routes.seasons_show_path(conn, :show, serie["id"], 1))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:serie, %{"serie" => serie, "number" => 1}})
    send(view.pid, {:episodes, Episodes.get_all(serie["id"], "1")})

    assert render(view) =~ "Play"
  end

  test "it should favourite", %{conn: conn} do
    serie = SeriesFixtures.get_serie()

    {:ok, view, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    assert Favourites.list_serie_favourites()
           |> Enum.empty?()

    send(view.pid, {:serie, serie})

    assert view |> element("#favourite", "Favourite") |> render_click()

    favourite =
      Favourites.list_serie_favourites()
      |> List.first()

    assert favourite.serie_id === serie["id"]
  end

  test "it should unfavourite", %{conn: conn} do
    serie = SeriesFixtures.get_serie()

    {:ok, view, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    send(view.pid, {:serie, serie})

    assert view
           |> element("#favourite", "Favourite")
           |> render_click()

    {:ok, view, _html} = live(conn, Routes.series_show_path(conn, :show, serie["id"]))

    send(view.pid, {:serie, serie})

    assert view
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
               "unverifiedSceneNumbering" => false,
               "tvdbId" => 0
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
               "unverifiedSceneNumbering" => false,
               "tvdbId" => 0
             },
             %{
               "airDate" => "2011-03-28",
               "airDateUtc" => "2011-03-28T04:00:00Z",
               "episodeFileId" => 3,
               "episodeNumber" => 3,
               "hasFile" => true,
               "id" => 3,
               "images" => [
                 %{
                   "coverType" => "screenshot",
                   "url" => "https://artworks.thetvdb.com/banners/episodes/170551/3990361.jpg"
                 }
               ],
               "monitored" => false,
               "overview" =>
                 "Now quarantined to the Calgary base for two weeks, Taylor and his team have bought time to get answers from the supposed Martian cosmonaut. But who can get him to talk?",
               "seasonNumber" => 1,
               "seriesId" => 1,
               "title" => "Alone in the Night",
               "unverifiedSceneNumbering" => false,
               "tvdbId" => 0
             }
           ]
  end
end
