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
end
