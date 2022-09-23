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
        name: "some name"
      })
      |> MediaServer.Playlists.create_playlist()

    playlist
  end

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url",
        movie_id: 42,
        title: "some title"
      })
      |> MediaServer.Playlists.create_movie()

    movie
  end
end
