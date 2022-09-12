defmodule MediaServer.PlaylistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Playlists` context.
  """

  @doc """
  Generate a playlist.
  """
  def playlist_fixture(attrs \\ %{}) do
    {:ok, playlist} =
      attrs
      |> Enum.into(%{
        can_delete: true,
        name: "some name"
      })
      |> MediaServer.Playlists.create_playlist()

    playlist
  end
end
