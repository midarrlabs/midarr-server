defmodule MediaServer.ContinuesFixtures do

  def create(attrs \\ %{}) do
    {:ok, %MediaServer.MediaTypes{} = media} = MediaServer.MediaTypes.create(%{type: "some type"})

    {:ok, continue} =
      attrs
      |> Enum.into(%{
        media_id: 42,
        current_time: 42,
        duration: 84,
        media_type_id: media.id
      })
      |> MediaServer.Accounts.UserContinues.create()

    continue
  end
end
