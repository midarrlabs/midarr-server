defmodule MediaServer.ActionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Actions` context.
  """

  alias MediaServer.AccountsFixtures
  alias MediaServer.Fixtures.UserActions

  def create(attrs \\ %{}) do
    action = UserActions.action_fixture()
    user = AccountsFixtures.user_fixture()

    {:ok, %MediaServer.MediaTypes{} = media} = MediaServer.MediaTypes.create(%{type: "some type"})

    {:ok, movie} =
      attrs
      |> Enum.into(%{
        media_id: 42,
        user_id: user.id,
        user_action_id: action.id,
        media_type_id: media.id
      })
      |> MediaServer.Accounts.UserMedia.create()

    movie
  end

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    action = UserActions.action_fixture()
    user = AccountsFixtures.user_fixture()

    {:ok, movie} =
      attrs
      |> Enum.into(%{
        movie_id: 42,
        title: "some title",
        user_id: user.id,
        user_action_id: action.id
      })
      |> MediaServer.Actions.create_movie()

    movie
  end

  @doc """
  Generate a episode.
  """
  def episode_fixture(attrs \\ %{}) do
    action = UserActions.action_fixture()
    user = AccountsFixtures.user_fixture()

    {:ok, episode} =
      attrs
      |> Enum.into(%{
        episode_id: 42,
        serie_id: 42,
        title: "some title",
        user_id: user.id,
        user_action_id: action.id
      })
      |> MediaServer.Actions.create_episode()

    episode
  end
end
