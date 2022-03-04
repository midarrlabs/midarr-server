defmodule MediaServer.SeriesFixtures do
  def get_url(url) do
    "#{Application.get_env(:media_server, :series_base_url)}/api/v3/#{url}?apikey=#{Application.get_env(:media_server, :series_api_key)}"
  end

  def add_series_root() do
    HTTPoison.post(get_url("rootFolder"), '{"path":"/shows/"}')
  end

  def add_series() do
    HTTPoison.post(
      get_url("series/import"),
      '[{"title":"Pioneer One","sortTitle":"pioneer one","status":"ended","ended":true,"overview":"An object in the sky spreads radiation over North America. Fearing terrorism, U.S. Homeland Security agents are dispatched to investigate and contain the damage. What they discover will have implications for the entire world.","images":[{"coverType":"banner","url":"/MediaCoverProxy/42d86cc749b551ae0179603fb9188f0c14dd8509ee27a6be1b4f8b70a5cbabbe/170551-g3.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/graphical/170551-g3.jpg"},{"coverType":"poster","url":"/MediaCoverProxy/2f3693c643154f5c2a9b319ee27b3011c3680763c5a523797a616fe21fa1cf3c/170551-1.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/posters/170551-1.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/aaa8d921fec9779b311164f51979499caec3e737401cc67ecdb736abc5e90711/170551-2.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/fanart/original/170551-2.jpg"}],"remotePoster":"https://artworks.thetvdb.com/banners/posters/170551-1.jpg","seasons":[{"seasonNumber":1,"monitored":true}],"year":2010,"qualityProfileId":1,"languageProfileId":1,"seasonFolder":true,"monitored":true,"useSceneNumbering":false,"runtime":30,"tvdbId":170551,"tvRageId":25990,"tvMazeId":4908,"firstAired":"2010-06-16T00:00:00Z","seriesType":"standard","cleanTitle":"pioneerone","imdbId":"tt1748166","titleSlug":"pioneer-one","folder":"Pioneer One","genres":["Drama","Science Fiction"],"added":"0001-01-01T00:00:00Z","ratings":{"votes":589,"value":7.5},"statistics":{"seasonCount":1,"episodeFileCount":0,"episodeCount":0,"totalEpisodeCount":0,"sizeOnDisk":0,"percentOfEpisodes":0},"addOptions":{"monitor":"none","searchForMissingEpisodes":false,"searchForCutoffUnmetEpisodes":false},"path":"/shows/Pioneer One"}]'
    )
  end

  def get_all() do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(get_url("series"))

    Jason.decode!(body)
  end

  def get_serie() do
    get_all() |> List.first()
  end

  def setup() do
    add_series_root()
    add_series()
  end

  def add_env() do
    Application.put_env(:media_server, :series_base_url, "sonarr:8989")
    Application.put_env(:media_server, :series_api_key, "1accda4476394bfcaddefe8c4fd77d4a")
  end

  def remove_env() do
    Application.delete_env(:media_server, :series_base_url)
    Application.delete_env(:media_server, :series_api_key)
  end
end
