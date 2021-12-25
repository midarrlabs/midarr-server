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

    radarr
  end
end
