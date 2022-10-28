defmodule MediaServer.ActionssFixtures do

  def create(attrs \\ %{}) do
    action = MediaServer.Fixtures.UserActions.action_fixture()
    user = MediaServer.AccountsFixtures.user_fixture()

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
end
