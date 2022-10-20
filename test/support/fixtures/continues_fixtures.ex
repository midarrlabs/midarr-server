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
