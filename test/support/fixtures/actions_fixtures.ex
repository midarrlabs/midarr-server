defmodule MediaServer.ActionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MediaServer.Actions` context.
  """

  alias MediaServer.AccountsFixtures
  alias MediaServer.ComponentsFixtures

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    action = ComponentsFixtures.action_fixture()
    user = AccountsFixtures.user_fixture()

    {:ok, movie} =
      attrs
      |> Enum.into(%{
        movie_id: 42,
        title: "some title",
        user_id: user.id,
        action_id: action.id
      })
      |> MediaServer.Actions.create_movie()

    movie
  end
end
