defmodule MediaServer.ContinuesFixtures do
  alias MediaServer.Continues

  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Continues` context.
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
      |> Continues.create_movie()

    movie
  end

  def get_movie_continue() do
    Continues.list_movie_continues() |> List.first()
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
      |> MediaServer.Continues.create_episode()

    episode
  end

  def get_episode_continue() do
    Continues.list_episode_continues() |> List.first()
  end
end
