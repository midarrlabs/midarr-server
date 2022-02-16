defmodule MediaServer.MoviesFixtures do

  def add_movie_root(integration) do
    HTTPoison.post("#{ integration.base_url }/api/v3/rootFolder?apiKey=#{ integration.api_key }", Jason.encode!(%{
      path: "/movies"
    }))
  end

  def add_movie(integration) do
    HTTPoison.post("#{ integration.base_url }/api/v3/movie/import?apiKey=#{ integration.api_key }", '[{"title":"Popeye the Sailor Meets Sindbad the Sailor","originalTitle":"Popeye the Sailor Meets Sindbad the Sailor","alternateTitles":[{"sourceType":"tmdb","movieId":0,"title":"Popeye el marino contra Sindbad el marino","sourceId":0,"votes":0,"voteCount":0,"language":{"id":3,"name":"Spanish"}},{"sourceType":"tmdb","movieId":0,"title":"POPEYE The Sailor-- Meets SINDBAD The Sailor","sourceId":0,"votes":0,"voteCount":0,"language":{"id":1,"name":"English"}}],"secondaryYearSourceId":0,"sortTitle":"popeye sailor meets sindbad sailor","sizeOnDisk":0,"status":"released","overview":"Two sailors Sindbad and Popeye decide to test themselves in order to prove their supremacy. Popeye is then presented with a series of daunting tasks by Sindbad.","inCinemas":"1936-11-27T00:00:00Z","images":[{"coverType":"poster","url":"/MediaCoverProxy/1001a443b0dca7fc39ff726fd413b13ab274d9cd6b871cc8d7ed25f025c9263b/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/4e93439432826373ba0b2475bb9e646d69ffad0ab32867637fdef2c24fa637dd/v72aGYqPcX5kLD1AVzsTXoxfS4d.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/v72aGYqPcX5kLD1AVzsTXoxfS4d.jpg"}],"website":"","remotePoster":"https://image.tmdb.org/t/p/original/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg","year":1936,"hasFile":false,"youTubeTrailerId":"","studio":"Fleischer Studios","qualityProfileId":1,"monitored":false,"minimumAvailability":"announced","isAvailable":true,"folderName":"","runtime":16,"cleanTitle":"popeyesailormeetssindbadsailor","imdbId":"tt0028119","tmdbId":67713,"titleSlug":"67713","folder":"Popeye the Sailor Meets Sindbad the Sailor (1936)","genres":["Animation","Adventure","Comedy"],"added":"0001-01-01T00:00:00Z","ratings":{"votes":67,"value":6.4},"addOptions":{"searchForMovie":false},"path":"/movies/Popeye the Sailor Meets Sindbad the Sailor(1936)"}]')
  end

  def setup() do
    integration = %{
      base_url: Application.fetch_env!(:media_server, :movies_base_url),
      api_key: Application.fetch_env!(:media_server, :movies_api_key)
    }

    add_movie_root(integration)
    add_movie(integration)
  end
end
