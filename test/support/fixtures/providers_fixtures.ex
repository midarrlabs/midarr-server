defmodule MediaServer.ProvidersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Providers` context.
  """

  @doc """
  Generate a sonarr.
  """
  def sonarr_fixture(attrs \\ %{}) do
    {:ok, sonarr} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        name: "some name",
        url: "some url"
      })
      |> MediaServer.Providers.create_sonarr()

    sonarr
  end

  def add_series_root(provider) do
    HTTPoison.post!("#{ provider.url }/rootFolder?apikey=#{ provider.api_key }", Jason.encode!(%{
      path: "/shows"
    }))
  end

  def add_series(provider) do
    case HTTPoison.get("#{ provider.url }/series?apikey=#{ provider.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        if length(decoded) !== 0 do

          series = Enum.at(decoded, 0)

          case HTTPoison.get("#{ provider.url }/episode?seriesId=#{ series["id"] }&apikey=#{ provider.api_key }") do

            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

              episode = Enum.filter(Jason.decode!(body), fn x -> x["hasFile"] end)
                                |> Enum.at(0)

              episode_id = episode["id"]

              series_id = series["id"]

              { series_id, episode_id }
          end
        else
          case HTTPoison.post("#{ provider.url }/series/import?apikey=#{ provider.api_key }", '[{"title":"The Beverly Hillbillies","sortTitle":"beverly hillbillies","status":"ended","ended":true,"overview":"The Beverly Hillbillies is among the most successful comedies in American television history, and remains one of the few sitcoms to involve serial plotlines. It centered around Jed Clampett, a simple backwoods mountaineer who becomes a millionaire when oil is discovered on his property and then moves his family to Beverly Hills. The fish-out-of-water farce ran for nine seasons.","network":"CBS","airTime":"19:30","images":[{"coverType":"banner","url":"/MediaCoverProxy/033b5d71e4e3939297f68892c846bee82de9aa63a6e187358efa8f06cbf70dd3/71471-g2.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/graphical/71471-g2.jpg"},{"coverType":"poster","url":"/MediaCoverProxy/27f38d8b79d2d56f2760b78530ad6581da35244546c3c0480ed957c6f231197d/71471-7.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/posters/71471-7.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/56492f722b55c21f01920d161f7a682f9aab6f83fdee7b7acd3783f9fe6a3cdd/71471-1.jpg","remoteUrl":"https://artworks.thetvdb.com/banners/fanart/original/71471-1.jpg"}],"remotePoster":"https://artworks.thetvdb.com/banners/posters/71471-7.jpg","seasons":[{"seasonNumber":0,"monitored":false},{"seasonNumber":1,"monitored":true},{"seasonNumber":2,"monitored":true},{"seasonNumber":3,"monitored":true},{"seasonNumber":4,"monitored":true},{"seasonNumber":5,"monitored":true},{"seasonNumber":6,"monitored":true},{"seasonNumber":7,"monitored":true},{"seasonNumber":8,"monitored":true},{"seasonNumber":9,"monitored":true}],"year":1962,"qualityProfileId":1,"languageProfileId":1,"seasonFolder":true,"monitored":true,"useSceneNumbering":false,"runtime":25,"tvdbId":71471,"tvRageId":5615,"tvMazeId":2139,"firstAired":"1962-09-26T00:00:00Z","seriesType":"standard","cleanTitle":"thebeverlyhillbillies","imdbId":"tt0055662","titleSlug":"the-beverly-hillbillies","folder":"The Beverly Hillbillies","certification":"TV-G","genres":["Comedy"],"added":"0001-01-01T00:00:00Z","ratings":{"votes":333,"value":9.3},"statistics":{"seasonCount":9,"episodeFileCount":0,"episodeCount":0,"totalEpisodeCount":0,"sizeOnDisk":0,"percentOfEpisodes":0},"addOptions":{"monitor":"none","searchForMissingEpisodes":false,"searchForCutoffUnmetEpisodes":false},"path":"/shows/The Beverly Hillbillies"}]') do

            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              Jason.decode!(body)

              case HTTPoison.get("#{ provider.url }/episode?seriesId=#{ body["id"] }&apikey=#{ provider.api_key }") do

                {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->

                  episode = Enum.filter(Jason.decode!(body), fn x -> x["hasFile"] end)
                            |> Enum.at(0)

                  episode_id = episode["id"]

                  series_id = body["id"]

                  { series_id, episode_id }
              end
          end
        end
    end
  end

  @doc """
  Generate a real sonarr.
  """
  def real_sonarr_fixture(attrs \\ %{}) do
    {:ok, sonarr} =
      attrs
      |> Enum.into(%{
        api_key: "1accda4476394bfcaddefe8c4fd77d4a",
        name: "Series",
        url: "test-sonarr:8989/api/v3"
      })
      |> MediaServer.Providers.create_sonarr()

    add_series_root(sonarr)
    { series_id, episode_id } = add_series(sonarr)

    {sonarr, series_id, episode_id}
  end

  @doc """
  Generate a radarr.
  """
  def radarr_fixture(attrs \\ %{}) do
    {:ok, radarr} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        name: "some name",
        url: "some url"
      })
      |> MediaServer.Providers.create_radarr()

    radarr
  end

  def add_movie_root(provider) do
    HTTPoison.post!("#{ provider.url }/rootFolder?apiKey=#{ provider.api_key }", Jason.encode!(%{
      path: "/movies"
    }))
  end

  def add_movie(provider) do
    case HTTPoison.get("#{ provider.url }/movie?apiKey=#{ provider.api_key }") do

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        decoded = Jason.decode!(body)

        if length(decoded) do
          movie = Enum.at(decoded, 0)

          movie["id"]

        else
          case HTTPoison.post("#{ provider.url }/movie/import?apiKey=#{ provider.api_key }", '[{"title":"Popeye the Sailor Meets Sindbad the Sailor","originalTitle":"Popeye the Sailor Meets Sindbad the Sailor","alternateTitles":[{"sourceType":"tmdb","movieId":0,"title":"Popeye el marino contra Sindbad el marino","sourceId":0,"votes":0,"voteCount":0,"language":{"id":3,"name":"Spanish"}},{"sourceType":"tmdb","movieId":0,"title":"POPEYE The Sailor-- Meets SINDBAD The Sailor","sourceId":0,"votes":0,"voteCount":0,"language":{"id":1,"name":"English"}}],"secondaryYearSourceId":0,"sortTitle":"popeye sailor meets sindbad sailor","sizeOnDisk":0,"status":"released","overview":"Two sailors Sindbad and Popeye decide to test themselves in order to prove their supremacy. Popeye is then presented with a series of daunting tasks by Sindbad.","inCinemas":"1936-11-27T00:00:00Z","images":[{"coverType":"poster","url":"/MediaCoverProxy/1001a443b0dca7fc39ff726fd413b13ab274d9cd6b871cc8d7ed25f025c9263b/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg"},{"coverType":"fanart","url":"/MediaCoverProxy/4e93439432826373ba0b2475bb9e646d69ffad0ab32867637fdef2c24fa637dd/v72aGYqPcX5kLD1AVzsTXoxfS4d.jpg","remoteUrl":"https://image.tmdb.org/t/p/original/v72aGYqPcX5kLD1AVzsTXoxfS4d.jpg"}],"website":"","remotePoster":"https://image.tmdb.org/t/p/original/Ae4r3014zCLSbaL9PiiFm9QGWXS.jpg","year":1936,"hasFile":false,"youTubeTrailerId":"","studio":"Fleischer Studios","qualityProfileId":1,"monitored":false,"minimumAvailability":"announced","isAvailable":true,"folderName":"","runtime":16,"cleanTitle":"popeyesailormeetssindbadsailor","imdbId":"tt0028119","tmdbId":67713,"titleSlug":"67713","folder":"Popeye the Sailor Meets Sindbad the Sailor (1936)","genres":["Animation","Adventure","Comedy"],"added":"0001-01-01T00:00:00Z","ratings":{"votes":67,"value":6.4},"addOptions":{"searchForMovie":false},"path":"/movies/Popeye the Sailor Meets Sindbad the Sailor(1936)"}]') do

            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              Jason.decode!(body)

              body["id"]
          end
        end
    end
  end

  @doc """
  Generate real radarr.
  """
  def real_radarr_fixture(attrs \\ %{}) do
    {:ok, radarr} =
      attrs
      |> Enum.into(%{
        api_key: "d031e8c9b9df4b2fab311d1c3b3fa2c5",
        name: "Movies",
        url: "test-radarr:7878/api/v3"
      })
      |> MediaServer.Providers.create_radarr()

    add_movie_root(radarr)
    movie_id = add_movie(radarr)

    {radarr, movie_id}
  end
end
