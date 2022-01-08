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

  @doc """
  Generate a real sonarr.
  """
  def real_sonarr_fixture(attrs \\ %{}) do
    {:ok, sonarr} =
      attrs
      |> Enum.into(%{
        api_key: "1accda4476394bfcaddefe8c4fd77d4a",
        name: "Series",
        url: "test-sonarr:8989/api"
      })
      |> MediaServer.Providers.create_sonarr()

    sonarr
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

    add_root_folder(radarr)
    movie_id = add_movie(radarr)

    {radarr, movie_id}
  end

  def add_root_folder(provider) do
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
end
