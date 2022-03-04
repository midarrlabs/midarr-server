defmodule MediaServer.WatchesFixtures do
  alias MediaServer.Watches

  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Watches` context.
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
        image_url: "some image url",
        current_time: 42,
        duration: 84
      })
      |> Watches.create_movie()

    movie
  end

  def get_movie_watch() do
    Watches.list_movie_watches() |> List.first()
  end

  @doc """
  Generate a episode.
  """
  def episode_fixture(attrs \\ %{}) do
    {:ok, episode} =
      attrs
      |> Enum.into(%{
        current_time: 42,
        duration: 42,
        episode_id: 42,
        image_url: "some image_url",
        serie_id: 42,
        title: "some title"
      })
      |> MediaServer.Watches.create_episode()

    episode
  end

  def get_episode_watch() do
    Watches.list_episode_watches() |> List.first()
  end
end
