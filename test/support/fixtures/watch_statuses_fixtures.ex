defmodule MediaServer.WatchStatusesFixtures do

  alias MediaServer.WatchStatuses
  alias MediaServer.AccountsFixtures

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
        title: "some title",
        image_url: "some image url",
        current_time: 42,
        duration: 84,
        user_id: AccountsFixtures.user_fixture().id
      })
      |> WatchStatuses.create_movie()

    movie
  end

  def get_watch_status() do
    WatchStatuses.list_movie_watch_statuses() |> List.first()
  end
end
