defmodule MediaServerWeb.SeriesLiveTest do
  use MediaServerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias MediaServer.AccountsFixtures
  alias MediaServerWeb.Repositories.Series
  alias MediaServerWeb.Repositories.Episodes

  setup %{conn: conn} do
    %{conn: conn |> log_in_user(AccountsFixtures.user_fixture())}
  end

  test "it should render index", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.series_index_path(conn, :index))

    series = Series.get_all() |> List.first()

    assert disconnected_html =~ series["title"]
  end

  test "it should render index paged", %{conn: conn} do
    {:ok, _view, disconnected_html} = live(conn, Routes.series_index_path(conn, :index, page: "1"))

    series = Series.get_all() |> List.first()

    assert disconnected_html =~ series["title"]
  end

  test "it should render show", %{conn: conn} do
    series = Series.get_all() |> List.first()

    {:ok, _view, disconnected_html} = live(conn, Routes.series_show_path(conn, :show, series["id"]))

    assert disconnected_html =~ series["title"]
  end

  test "it should render season", %{conn: conn} do
    series = Series.get_all() |> List.first()

    {:ok, view, disconnected_html} =
      live(conn, Routes.seasons_show_path(conn, :show, series["id"], 1))

    assert disconnected_html =~ "loading-spinner"

    send(view.pid, {:episodes, Episodes.get_all(series["id"], "1")})

    assert render(view) =~ "Play"
    assert render(view) =~ "5:24"
    assert render(view) =~ "5:19"
  end

  test "it should replace each episode with episode show response", %{conn: _conn} do
    series = Series.get_all() |> List.first()

    episodes = Episodes.get_all(series["id"], "1")

    assert Map.get(Enum.at(episodes, 0), "episodeNumber") === 1
    assert Map.get(Enum.at(episodes, 1), "episodeNumber") === 2
    assert Map.get(Enum.at(episodes, 2), "episodeNumber") === 3
  end

  @doc """
      [
        %{
          "airDate" => "2010-06-16",
          "airDateUtc" => "2010-06-16T04:00:00Z",
          "episodeFile" => %{
            "dateAdded" => "2022-08-29T06:14:01.307057Z",
            "id" => 1,
            "language" => %{"id" => 1, "name" => "English"},
            "languageCutoffNotMet" => false,
            "mediaInfo" => %{
              "audioBitrate" => 125996,
              "audioChannels" => 2.0,
              "audioCodec" => "AAC",
              "audioLanguages" => "English",
              "audioStreamCount" => 1,
              "resolution" => "1280x720",
              "runTime" => "5:24",
              "scanType" => "Progressive",
              "subtitles" => "",
              "videoBitDepth" => 8,
              "videoBitrate" => 1042329,
              "videoCodec" => "x264",
              "videoDynamicRange" => "",
              "videoDynamicRangeType" => "",
              "videoFps" => 23.976
            },
            "path" => "/shows/Pioneer One/Season 1/Pioneer.One.S01E01.Earthfall.720p.mp4",
            "quality" => %{
              "quality" => %{
                "id" => 4,
                "name" => "HDTV-720p",
                "resolution" => 720,
                "source" => "television"
              },
              "revision" => %{"isRepack" => false, "real" => 0, "version" => 1}
            },
            "qualityCutoffNotMet" => false,
            "relativePath" => "Season 1/Pioneer.One.S01E01.Earthfall.720p.mp4",
            "seasonNumber" => 1,
            "seriesId" => 1,
            "size" => 47552617
          },
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
          "series" => %{
            "added" => "2022-08-29T06:14:00.073926Z",
            "cleanTitle" => "pioneerone",
            "ended" => true,
            "firstAired" => "2010-06-16T00:00:00Z",
            "genres" => ["Drama", "Science Fiction"],
            "id" => 1,
            "images" => [
              %{
                "coverType" => "banner",
                "url" => "https://artworks.thetvdb.com/banners/graphical/170551-g3.jpg"
              },
              %{
                "coverType" => "poster",
                "url" => "https://artworks.thetvdb.com/banners/posters/170551-1.jpg"
              },
              %{
                "coverType" => "fanart",
                "url" =>
                  "https://artworks.thetvdb.com/banners/fanart/original/170551-1.jpg"
              }
            ],
            "imdbId" => "tt1748166",
            "languageProfileId" => 1,
            "monitored" => false,
            "overview" =>
              "An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.",
            "path" => "/shows/Pioneer One",
            "qualityProfileId" => 1,
            "ratings" => %{"value" => 7.5, "votes" => 589},
            "runtime" => 30,
            "seasonFolder" => true,
            "seasons" => [%{"monitored" => false, "seasonNumber" => 1}],
            "seriesType" => "standard",
            "sortTitle" => "pioneer one",
            "status" => "ended",
            "tags" => [],
            "title" => "Pioneer One",
            "titleSlug" => "pioneer-one",
            "tvMazeId" => 4908,
            "tvRageId" => 25990,
            "tvdbId" => 170551,
            "useSceneNumbering" => false,
            "year" => 2010
          },
          "seriesId" => 1,
          "title" => "Earthfall",
          "tvdbId" => 2375761,
          "unverifiedSceneNumbering" => false
        },
        %{
          "airDate" => "2010-06-25",
          "airDateUtc" => "2010-06-25T04:00:00Z",
          "episodeFile" => %{
            "dateAdded" => "2022-08-29T06:14:01.40923Z",
            "id" => 2,
            "language" => %{"id" => 1, "name" => "English"},
            "languageCutoffNotMet" => false,
            "mediaInfo" => %{
              "audioBitrate" => 128507,
              "audioChannels" => 2.0,
              "audioCodec" => "AAC",
              "audioLanguages" => "English",
              "audioStreamCount" => 1,
              "resolution" => "1280x720",
              "runTime" => "5:19",
              "scanType" => "Progressive",
              "subtitles" => "",
              "videoBitDepth" => 8,
              "videoBitrate" => 1076138,
              "videoCodec" => "x264",
              "videoDynamicRange" => "",
              "videoDynamicRangeType" => "",
              "videoFps" => 23.976
            },
            "path" =>
              "/shows/Pioneer One/Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4",
            "quality" => %{
              "quality" => %{
                "id" => 4,
                "name" => "HDTV-720p",
                "resolution" => 720,
                "source" => "television"
              },
              "revision" => %{"isRepack" => false, "real" => 0, "version" => 1}
            },
            "qualityCutoffNotMet" => false,
            "relativePath" => "Season 1/Pioneer.One.S01E02.The.Man.From.Mars.720p.mp4",
            "seasonNumber" => 1,
            "seriesId" => 1,
            "size" => 48292845
          },
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
          "series" => %{
            "added" => "2022-08-29T06:14:00.073926Z",
            "cleanTitle" => "pioneerone",
            "ended" => true,
            "firstAired" => "2010-06-16T00:00:00Z",
            "genres" => ["Drama", "Science Fiction"],
            "id" => 1,
            "images" => [
              %{
                "coverType" => "banner",
                "url" => "https://artworks.thetvdb.com/banners/graphical/170551-g3.jpg"
              },
              %{
                "coverType" => "poster",
                "url" => "https://artworks.thetvdb.com/banners/posters/170551-1.jpg"
              },
              %{
                "coverType" => "fanart",
                "url" =>
                  "https://artworks.thetvdb.com/banners/fanart/original/170551-1.jpg"
              }
            ],
            "imdbId" => "tt1748166",
            "languageProfileId" => 1,
            "monitored" => false,
            "overview" =>
              "An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.",
            "path" => "/shows/Pioneer One",
            "qualityProfileId" => 1,
            "ratings" => %{"value" => 7.5, "votes" => 589},
            "runtime" => 30,
            "seasonFolder" => true,
            "seasons" => [%{"monitored" => false, "seasonNumber" => 1}],
            "seriesType" => "standard",
            "sortTitle" => "pioneer one",
            "status" => "ended",
            "tags" => [],
            "title" => "Pioneer One",
            "titleSlug" => "pioneer-one",
            "tvMazeId" => 4908,
            "tvRageId" => 25990,
            "tvdbId" => 170551,
            "useSceneNumbering" => false,
            "year" => 2010
          },
          "seriesId" => 1,
          "title" => "The Man From Mars",
          "tvdbId" => 3294321,
          "unverifiedSceneNumbering" => false
        },
        %{
          "airDate" => "2011-03-28",
          "airDateUtc" => "2011-03-28T04:00:00Z",
          "episodeFile" => %{
            "dateAdded" => "2022-08-29T06:14:01.417035Z",
            "id" => 3,
            "language" => %{"id" => 1, "name" => "English"},
            "languageCutoffNotMet" => false,
            "mediaInfo" => %{
              "audioBitrate" => 128507,
              "audioChannels" => 2.0,
              "audioCodec" => "AAC",
              "audioLanguages" => "English",
              "audioStreamCount" => 1,
              "resolution" => "1280x720",
              "runTime" => "5:19",
              "scanType" => "Progressive",
              "subtitles" => "",
              "videoBitDepth" => 8,
              "videoBitrate" => 1076138,
              "videoCodec" => "x264",
              "videoDynamicRange" => "",
              "videoDynamicRangeType" => "",
              "videoFps" => 23.976
            },
            "path" =>
              "/shows/Pioneer One/Season 1/Pioneer.One.S01E03.Alone.in.the.Night.720p.mp4",
            "quality" => %{
              "quality" => %{
                "id" => 4,
                "name" => "HDTV-720p",
                "resolution" => 720,
                "source" => "television"
              },
              "revision" => %{"isRepack" => false, "real" => 0, "version" => 1}
            },
            "qualityCutoffNotMet" => false,
            "relativePath" => "Season 1/Pioneer.One.S01E03.Alone.in.the.Night.720p.mp4",
            "seasonNumber" => 1,
            "seriesId" => 1,
            "size" => 48292845
          },
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
          "series" => %{
            "added" => "2022-08-29T06:14:00.073926Z",
            "cleanTitle" => "pioneerone",
            "ended" => true,
            "firstAired" => "2010-06-16T00:00:00Z",
            "genres" => ["Drama", "Science Fiction"],
            "id" => 1,
            "images" => [
              %{
                "coverType" => "banner",
                "url" => "https://artworks.thetvdb.com/banners/graphical/170551-g3.jpg"
              },
              %{
                "coverType" => "poster",
                "url" => "https://artworks.thetvdb.com/banners/posters/170551-1.jpg"
              },
              %{
                "coverType" => "fanart",
                "url" =>
                  "https://artworks.thetvdb.com/banners/fanart/original/170551-1.jpg"
              }
            ],
            "imdbId" => "tt1748166",
            "languageProfileId" => 1,
            "monitored" => false,
            "overview" =>
              "An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.",
            "path" => "/shows/Pioneer One",
            "qualityProfileId" => 1,
            "ratings" => %{"value" => 7.5, "votes" => 589},
            "runtime" => 30,
            "seasonFolder" => true,
            "seasons" => [%{"monitored" => false, "seasonNumber" => 1}],
            "seriesType" => "standard",
            "sortTitle" => "pioneer one",
            "status" => "ended",
            "tags" => [],
            "title" => "Pioneer One",
            "titleSlug" => "pioneer-one",
            "tvMazeId" => 4908,
            "tvRageId" => 25990,
            "tvdbId" => 170551,
            "useSceneNumbering" => false,
            "year" => 2010
          },
          "seriesId" => 1,
          "title" => "Alone in the Night",
          "tvdbId" => 3990361,
          "unverifiedSceneNumbering" => false
        }
      ]
  """
end
