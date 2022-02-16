defmodule MediaServer.SeriesFixtures do

  alias MediaServerWeb.Repositories.Series

  def add_series_root() do
    HTTPoison.post(Series.get_url("rootFolder"), Jason.encode!(%{
      path: "/shows"
    }))
  end

  def add_series() do
    HTTPoison.post(Series.get_url("series/import"), '[{"title":"The Beverly Hillbillies","sortTitle":"beverly hillbillies","status":"ended","ended":true,"overview":"The Beverly Hillbillies is among the most successful comedies in American television history, and remains one of the few sitcoms to involve serial plotlines. It centered around Jed Clampett, a simple backwoods mountaineer who becomes a millionaire when oil is discovered on his property and then moves his family to Beverly Hills. The fish-out-of-water farce ran for nine seasons.","network":"CBS","airTime":"19:30","images":[{"coverType":"banner","url":"/MediaCoverProxy/033b5d71e4e3939297f68892c846bee82de9aa63a6e187358efa8f06cbf70dd3/71471-g2.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/graphical/71471-g2.jpg"},{"coverType":"poster","url":"/MediaCoverProxy/27f38d8b79d2d56f2760b78530ad6581da35244546c3c0480ed957c6f231197d/71471-7.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/posters/71471-7.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/56492f722b55c21f01920d161f7a682f9aab6f83fdee7b7acd3783f9fe6a3cdd/71471-1.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/fanart/original/71471-1.jpg"}],"remotePoster":"https://artworks.thetvdb.com/banners/posters/71471-7.jpg","seasons":[{"seasonNumber":0,"monitored":false},{"seasonNumber":1,"monitored":true},{"seasonNumber":2,"monitored":true},{"seasonNumber":3,"monitored":true},{"seasonNumber":4,"monitored":true},{"seasonNumber":5,"monitored":true},{"seasonNumber":6,"monitored":true},{"seasonNumber":7,"monitored":true},{"seasonNumber":8,"monitored":true},{"seasonNumber":9,"monitored":true}],"year":1962,"qualityProfileId":1,"languageProfileId":1,"seasonFolder":true,"monitored":true,"useSceneNumbering":false,"runtime":25,"tvdbId":71471,"tvRageId":5615,"tvMazeId":2139,"firstAired":"1962-09-26T00:00:00Z","seriesType":"standard","cleanTitle":"thebeverlyhillbillies","imdbId":"tt0055662","titleSlug":"the-beverly-hillbillies","folder":"The Beverly Hillbillies","certification":"TV-G","genres":["Comedy"],"added":"0001-01-01T00:00:00Z","ratings":{"votes":333,"value":9.3},"statistics":{"seasonCount":9,"episodeFileCount":0,"episodeCount":0,"totalEpisodeCount":0,"sizeOnDisk":0,"percentOfEpisodes":0},"addOptions":{"monitor":"none","searchForMissingEpisodes":false,"searchForCutoffUnmetEpisodes":false},"path":"/shows/The Beverly Hillbillies"}]')
  end

  def get_all() do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(Series.get_url("series"))

    Jason.decode!(body)
  end

  def get_serie() do
    get_all() |> List.first()
  end

  def setup() do
    add_series_root()
    add_series()
  end
end
