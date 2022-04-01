defmodule MediaServer.FavouritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Favourites` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        movie_id: 42,
        title: "some title",
        image_url: "some image url"
      })
      |> MediaServer.Favourites.create_movie()

    movie
  end

  @doc """
  Generate a serie.
  """
  def serie_fixture(attrs \\ %{}) do
    {:ok, serie} =
      attrs
      |> Enum.into(%{
        serie_id: 42,
        title: "some title",
        image_url: "some image url"
      })
      |> MediaServer.Favourites.create_serie()

    serie
  end
end
