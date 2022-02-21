defmodule MediaServer.WatchStatusesFixtures do

  alias MediaServer.WatchStatuses

  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.WatchStatuses` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        movie_id: 42,
        timestamp: 42
      })
      |> MediaServer.WatchStatuses.create_movie()

    movie
  end

  def get_watch_status() do
    MediaServer.WatchStatuses.list_movie_watch_statuses() |> List.first()
  end
end
