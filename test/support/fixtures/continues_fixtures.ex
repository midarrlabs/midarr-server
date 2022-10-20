defmodule MediaServer.ContinuesFixtures do
  alias MediaServer.Continues

  def create(attrs \\ %{}) do
    {:ok, continue} =
      attrs
      |> Enum.into(%{
        media_id: 42,
        current_time: 42,
        duration: 84,
        media_type_id: MediaServer.MediaTypes.get_id("movie")
      })
      |> MediaServer.Accounts.UserContinues.create()

    continue
  end

  def create_episode(attrs \\ %{}) do
    {:ok, continue} =
      attrs
      |> Enum.into(%{
        media_id: 42,
        current_time: 42,
        duration: 84,
        media_type_id: MediaServer.MediaTypes.get_id("episode")
      })
      |> MediaServer.Accounts.UserContinues.create()

    continue
  end
end
