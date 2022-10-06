defmodule MediaServer.Seeds.Movies do

  alias MediaServerWeb.Repositories.Movies

  def add_root() do
    HTTPoison.post!(Movies.get_url("rootFolder"), '{"path":"/movies/"}', %{
      "Content-Type" => "application/json"
    })
  end

  def add_movies() do
    HTTPoison.post!(
      Movies.get_url("movie/import"),
      '[{"title":"Caminandes: Llama Drama","originalTitle":"Caminandes: Llama Drama","secondaryYearSourceId":0,"sortTitle":"caminandes llama drama","sizeOnDisk":0,"status":"released","overview":"Koro wants to get to the other side of the road.","inCinemas":"2013-02-10T00:00:00Z","images":[{"coverType":"poster","url":"/MediaCoverProxy/3d62c85c7fd96f6c48be9f7a8c0ee717f1ac03e3e93daf2f2c9eb15c809aa482/66VPke0YSiyfe97aobbcZ55ts56.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/fa0751d4a0fcf15f65224398456a3b33ab1b2b6ad0a8f98b94d8fcd1d2934137/mjkoC8Vo7fSHuqrbVQdI6cNwKA2.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/mjkoC8Vo7fSHuqrbVQdI6cNwKA2.jpg"}],"website":"http://www.caminandes.com/","remotePoster":"https://image.tmdb.org/t/p/original/66VPke0YSiyfe97aobbcZ55ts56.jpg","year":2013,"hasFile":false,"youTubeTrailerId":"","studio":"","qualityProfileId":1,"monitored":false,"minimumAvailability":"announced","isAvailable":true,"folderName":"","runtime":2,"cleanTitle":"caminandesllamadrama","imdbId":"tt6059374","tmdbId":253777,"titleSlug":"253777","folder":"Caminandes Llama Drama (2013)","genres":["Animation","Family","Comedy"],"added":"0001-01-01T00:00:00Z","ratings":{"imdb":{"votes":42,"value":6.8,"type":"user"},"tmdb":{"votes":7,"value":7,"type":"user"}},"collection":{"name":"Caminandes Collection","tmdbId":339473,"images":[]},"addOptions":{"searchForMovie":false},"path":"/movies/Caminandes Llama Drama (2013)"}]',
      %{"Content-Type" => "application/json"}
    )

    HTTPoison.post!(
      Movies.get_url("movie/import"),
      '[{"title":"Caminandes: Gran Dillama","originalTitle":"Caminandes: Gran Dillama","secondaryYearSourceId":0,"sortTitle":"caminandes gran dillama","sizeOnDisk":0,"status":"released","overview":"A young llama named Koro discovers that the grass is always greener on the other side (of the fence).","inCinemas":"2013-11-22T00:00:00Z","images":[{"coverType":"poster","url":"/MediaCoverProxy/e06f403dc64d7a583660ce6ea6e1da81018aa7cc4cbcb7d675bf019a71e14bc6/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/a36c3406dfc4e5db54cd27f8889aaac292ad8bb29f62bb797883034ac17f58b7/206A3X9EH42kmdQMECq90SbjHCn.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/206A3X9EH42kmdQMECq90SbjHCn.jpg"}],"website":"http://www.caminandes.com","remotePoster":"https://image.tmdb.org/t/p/original/7YtEiEzRBVCr8Sbgo1kVsr3OCMk.jpg","year":2013,"hasFile":false,"youTubeTrailerId":"","studio":"","qualityProfileId":1,"monitored":false,"minimumAvailability":"announced","isAvailable":true,"folderName":"","runtime":3,"cleanTitle":"caminandesgrandillama","imdbId":"tt3434172","tmdbId":253774,"titleSlug":"253774","folder":"Caminandes Gran Dillama (2013)","genres":["Animation","Comedy","Family"],"added":"0001-01-01T00:00:00Z","ratings":{"imdb":{"votes":97,"value":7,"type":"user"},"tmdb":{"votes":12,"value":7.3,"type":"user"}},"collection":{"name":"Caminandes Collection","tmdbId":339473,"images":[]},"addOptions":{"searchForMovie":false},"path":"/movies/Caminandes Gran Dillama (2013)"}]',
      %{"Content-Type" => "application/json"}
    )

    HTTPoison.post!(
      Movies.get_url("movie/import"),
      '[{"title":"Caminandes: Llamigos","originalTitle":"Caminandes: Llamigos","secondaryYearSourceId":0,"sortTitle":"caminandes llamigos","sizeOnDisk":0,"status":"released","overview":"In this episode of the Caminandes cartoon series we learn to know our hero Koro even better! Its winter in Patagonia, food is getting scarce. Koro the Llama engages with Oti the pesky penguin in an epic fight over that last tasty berry.  This short animation film was made with Blender and funded by the subscribers of the Blender Cloud platform. Already since 2007, Blender Institute successfully combines film and media production with improving a free and open source 3D creation pipeline.","digitalRelease":"2016-01-30T00:00:00Z","images":[{"coverType":"poster","url":"/MediaCoverProxy/1cd0fa3a941a3ffa3d9bcdd9fcd431cfdc4d0f5a919300c8d8dd739e45626038/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/b3d1da2004e5af4893757b1fd8bb78893c14d66257475682321842337ca0873e/VGqDyS1rp0IQcuFGInQzmfDFAj.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/VGqDyS1rp0IQcuFGInQzmfDFAj.jpg"}],"website":"http://www.caminandes.com","remotePoster":"https://image.tmdb.org/t/p/original/753kJbZ5iS7DUomTKX9qF5Cs5NY.jpg","year":2016,"hasFile":false,"youTubeTrailerId":"6U1bsPCLLEg","studio":"Blender Foundation","qualityProfileId":1,"monitored":false,"minimumAvailability":"announced","isAvailable":true,"folderName":"","runtime":3,"cleanTitle":"caminandesllamigos","imdbId":"tt7993892","tmdbId":406956,"titleSlug":"406956","folder":"Caminandes Llamigos (2016)","genres":["Animation","Comedy","Family"],"added":"0001-01-01T00:00:00Z","ratings":{"imdb":{"votes":46,"value":6.9,"type":"user"},"tmdb":{"votes":7,"value":6.7,"type":"user"}},"collection":{"name":"Caminandes Collection","tmdbId":339473,"images":[]},"addOptions":{"searchForMovie":false},"path":"/movies/Caminandes Llamigos (2016)"}]',
      %{"Content-Type" => "application/json"}
    )
  end

  def seed() do
    add_root()
    add_movies()
  end
end
